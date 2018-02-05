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
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = ["public.image"]
                self.present(imagePickerController, animated: true) { () -> Void in
                }
            }))
            alert.addAction(UIAlertAction(title: "打开相册", style: .default, handler: { (action) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.mediaTypes = ["public.image"]
                self.present(imagePickerController, animated: true) { () -> Void in
                }
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
        
        let thirdOfWidth = (self.view.frame.size.width - 3) / 3
        uploadImagesLayout.itemSize = CGSize(width: thirdOfWidth, height: thirdOfWidth)
        
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
        
        print(">>>\(mediaType)")
        
        //如果媒体是照片
        if mediaType == kUTTypeImage as String {
            //获取到拍摄的照片, UIImagePickerControllerEditedImage是经过剪裁过的照片,UIImagePickerControllerOriginalImage是原始的照片
            let image = info[UIImagePickerControllerEditedImage] as! UIImage
            
            if picker.sourceType == .camera {
                //调用方法保存到图像库中
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                uploadImagesDataSource?.addImage(image: image)
                uploadImagesHelper?.refresh()
            }
        }
        
        //关闭照相框
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            uploadImagesDataSource?.addImage(image: image)
            uploadImagesHelper?.refresh()
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func report() {
        if let input = reportText.text {
            TaoKeApi.report(input).rxSchedulerHelper()
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
