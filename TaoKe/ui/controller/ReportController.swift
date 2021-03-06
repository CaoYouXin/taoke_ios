import UIKit
import FontAwesomeKit
import RxSwift

class ReportController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var reportText: UITextView!
    @IBOutlet weak var uploadImages: UICollectionView!
    @IBOutlet weak var uploadImagesLayout: UICollectionViewFlowLayout!
    
    private let reportHint = "反馈内容"
    private var uploadImagesHelper: MVCHelper<UploadImageItem>?
    private var uploadImagesDataSource: UploadImageDataSource?
    private let disposeBag = DisposeBag()
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.elementsEqual(reportHint) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count < 1 {
            textView.text = reportHint
            textView.textColor = UIColor.gray
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "反馈"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.plain, target: self, action: #selector(report))
        
        reportText.delegate = self
        reportText.text = reportHint
        reportText.textColor = UIColor.gray
        
        reportText.layer.borderWidth = 1
        reportText.layer.borderColor = UIColor("#EED533").cgColor
        reportText.layer.cornerRadius = 5
        
        initUploadImages()
    }
    
    public func on(_ event: Event<UploadImageItem>) {
        MainScheduler.ensureExecutingOnScheduler()
        
        switch event {
        case .next(let element):
            if !element.isHandle! {
                break
            }
            
            let alert = UIAlertController(title: "提示", message: "您可以选择打开[相机]或者[相册]来上传一张图片.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "打开相机", style: .default, handler: { (action) in
                let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
                if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
                    self.view.makeToast("应用相机权限受限,请在iPhone的“设置-隐私-相机”选项中，允许觅券儿访问你的相机。")
                    return
                }
                
                if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.view.makeToast("您的相机不可用!")
                    return
                }
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = ["public.image"]
                self.present(imagePickerController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "打开相册", style: .default, handler: { (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.mediaTypes = ["public.image"]
                self.present(imagePickerController, animated: true)
            }))
            self.present(alert, animated: true)
        case .error:
            break
        case .completed:
            break
        }
    }
    
    private func initUploadImages() {
        uploadImages.register(UINib(nibName: "UploadImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let thirdOfWidth = self.view.frame.size.width / 3
        self.uploadImagesLayout.itemSize = CGSize(width: thirdOfWidth, height: thirdOfWidth)
        
        uploadImagesHelper = MVCHelper<UploadImageItem>(uploadImages)
        uploadImagesHelper?.set(cellFactory: { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UploadImageCell
            
            cell.uploadingMask.isHidden = element.uploaded!
            cell.thumb.isHidden = element.isHandle!
            
            if let image = element.image {
                cell.thumb.image = image
            }
            
            return cell
        })
        
        uploadImagesDataSource = UploadImageDataSource(self)
        uploadImagesHelper?.set(dataSource: uploadImagesDataSource)
//        uploadImagesHelper?.set(dataHook: { (data) -> [UploadImageItem] in
//
//            return data
//        })
        
        uploadImages.rx.itemSelected
            .map{ indexPath -> UploadImageItem in
                return try self.uploadImages.rx.model(at: indexPath)
            }
            .bind(to: AnyObserver(eventHandler: on))
            .disposed(by: disposeBag)
        
        uploadImagesHelper?.refresh()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取媒体的类型
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        //如果媒体是照片
        if mediaType == kUTTypeImage as String {
            //获取到拍摄的照片, UIImagePickerControllerEditedImage是经过剪裁过的照片,UIImagePickerControllerOriginalImage是原始的照片
            let image = info[UIImagePickerControllerEditedImage] as! UIImage
            
            if picker.sourceType == .camera {
                //调用方法保存到图像库中
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                self.addImage(image: image)
            }
        }
        
        //关闭照相框
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addImage(image: UIImage) {
        uploadImagesDataSource?.addImage(image: image)
        uploadImagesHelper?.refresh()
        
        TaoKeApi.uploadImage(image: image)
            .rxSchedulerHelper()
            .handleApiError(self)
            .subscribe(onNext: { (codeSource) in
                self.uploadImagesDataSource?.setImageCode(image: image, codeSource: codeSource)
                self.uploadImagesHelper?.refresh()
            }).disposed(by: disposeBag)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            self.addImage(image: image)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func report() {
        if let input = reportText.text {
            if input == "" {
                let ac = UIAlertController(title: "提示", message: "反馈内容不能为空", preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
                return
            }
            
            var content = """
            ---
            title: 来自\((UserData.get()?.phone)!)的反馈
            ---
            \(input)
            > 附件
            >
            """
            
            if let items = uploadImagesDataSource?.getData() {
                for item in items {
                    if item.isHandle! {
                        continue
                    }
                    
                    content += """
                    
                    >
                    > \(item.code!)
                    
                    """
                }
            }
            
            TaoKeApi.sendFeedback(content: content)
                .rxSchedulerHelper()
                .handleApiError(self, { _ in
                    self.navigationController?.popViewController(animated: true)
                }).subscribe(onNext: { _ in
                    let alert = UIAlertController(title: "", message: "我们已经收到您的反馈信息！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true)
                }).disposed(by: disposeBag)
        }
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
