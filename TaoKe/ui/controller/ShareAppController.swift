
import CleanroomLogger
import UIKit
import FontAwesomeKit
import RxSwift
import ELWaterFallLayout
import RxBus
import Kingfisher
import QRCode

class ShareAppController: UIViewController {
    
    @IBOutlet weak var generateZone: UIView!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var specification: UILabel!
    @IBOutlet weak var shareTemplateList: UICollectionView!
    
    private var cache: [Int: CGFloat] = [:]
    private var shareTemplateDS: ShareTemplateDataSource?
    private var busy = true
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        
        navigationItem.title = "分享给好友"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.plain, target: self, action: #selector(share))
        
        initShareTemplates()
        initGenerateZone()
        
        TaoKeApi.getDownloadUrl().rxSchedulerHelper().handleApiError(self)
            .subscribe(onNext: { (downloadUrl) in
                var qr = QRCode(downloadUrl)
                qr?.size = CGSize(width: self.qrCode.frame.size.width - 6, height: self.qrCode.frame.size.height - 6)
                self.qrCode.image = qr?.image
                self.busy = false
            }).disposed(by: disposeBag)
    }
    
    private func initGenerateZone() {
        if (UserData.get()?.isBuyer())! {
            specification.text = "识别二维码可打开应用市场"
        } else {
            let text = "邀请码\n->\(UserData.get()?.shareCode! ?? "")<-\n识别二维码可打开应用市场"
            let location = text.index(of: ">")!.encodedOffset + 1
            let length = text.index(of: "<")!.encodedOffset - location
            let range = NSRange(location: location, length: length)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: range)
            attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 22), range: range)
            specification.attributedText = attributedText
        }
        specification.preferredMaxLayoutWidth = self.view.frame.width / 18 * 11 - 80
        specification.textAlignment = .left;
        specification.numberOfLines = 0;
        specification.sizeToFit()
    }
    
    private func initShareTemplates() {
        let shareTemplateLayout = ELWaterFlowLayout()
        shareTemplateList.collectionViewLayout = shareTemplateLayout
        
        shareTemplateLayout.delegate = self
        shareTemplateLayout.lineCount = 1
        shareTemplateLayout.vItemSpace = 10
        shareTemplateLayout.hItemSpace = 10
        shareTemplateLayout.edge = UIEdgeInsets.zero
        shareTemplateLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        //refresh layout
        RxBus.shared.asObservable(event: Events.WaterFallLayout.self)
            .throttle(RxTimeInterval(1), latest: true, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .rxSchedulerHelper()
            .subscribe { event in
                shareTemplateLayout.lineCount = 1
            }.disposed(by: disposeBag)
        
        let shareTemplateFac: (UICollectionView, Int, ShareImage) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShareTemplateCell
            
            if (self.cache[row] ?? 0 == 0) {
                cell.template.layer.borderWidth = 1
                cell.template.layer.borderColor = UIColor("#bdbdbd").cgColor
                cell.template.addConstraint(NSLayoutConstraint(item: cell.template, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0))
                cell.template.kf.setImage(with: URL(string: element.thumb!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                    if let tmp = image {
                        let ratio = tmp.size.width / tmp.size.height
                        let width = cell.template.frame.height * ratio
                        
                        if let constraint = (cell.template.constraints.filter{$0.firstAttribute == NSLayoutAttribute.width}.first) {
                            constraint.constant = width
                        }
                        
                        self.cache[row] = width
                        RxBus.shared.post(event: Events.WaterFallLayout())
                    }
                })
            }
            
            let checkCircleIcon = FAKFontAwesome.checkCircleIcon(withSize: 24)
            checkCircleIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor(element.selected! ? "#e65100" : "#00000080"))
            cell.select.image = checkCircleIcon?.image(with: CGSize(width: 24, height: 24))
            return cell
        }
        
        shareTemplateDS = ShareTemplateDataSource(viewController: self)
        shareTemplateDS?.selected = -1
        
        let shareTemplateDH: ([ShareImage]) -> [ShareImage] = {
            shareImages in
            if shareImages.count > 0 && self.shareTemplateDS?.selected == -1 {
                shareImages[0].selected = true
            }
            return shareImages
        }
        
        let shareTempalteHelper = MVCHelper<ShareImage>(shareTemplateList)
        
        shareTempalteHelper.set(cellFactory: shareTemplateFac)
        shareTempalteHelper.set(dataSource: shareTemplateDS)
        shareTempalteHelper.set(dataHook: shareTemplateDH)
        
        shareTempalteHelper.refresh()
        
        shareTemplateList.rx.itemSelected.subscribe(onNext: { indexPath in
            self.shareTemplateDS?.selected = indexPath.row
            shareTempalteHelper.refresh()
        }, onError: { error in
            Log.error?.message(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func share() {
        if self.busy {
            let alert = UIAlertController(title: "", message: "正在生成二维码，请稍后重试", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
            }))
            self.present(alert, animated: true)
            return
        }
        
        if let generateShareImage = self.generateShareImage(false) {
            self.view.makeToastActivity(.center)
            generateShareImage.subscribe(onNext: { shareImage in
                self.view.hideToastActivity()
                
                var actvityItems:[Any] = []
                if let image = shareImage {
                    actvityItems.append(image)
                }
                
                let activityViewController = UIActivityViewController(activityItems: actvityItems, applicationActivities: nil)
                self.present(activityViewController, animated: true)
                
            }, onError: { (error) in
                self.view.hideToastActivity()
                Log.error?.message(error.localizedDescription)
            }).disposed(by: self.disposeBag)
        }
    }
    
    private func fetchShareImages(_ save: Bool) -> Observable<[UIImage?]>? {
        var observables: [Observable<UIImage?>] = []
        if let shareImages = self.shareTemplateDS?.cache {
            for i in 0..<shareImages.count {
                let shareImage = shareImages[i]
                if shareImage.selected! {
                    observables.append(Observable.create({ (observer) -> Disposable in
                        KingfisherManager.shared.downloader.downloadImage(with: URL(string: shareImage.thumb!)!, retrieveImageTask: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, url, data) in
                            if let data = image {
                                if save {
                                    UIImageWriteToSavedPhotosAlbum(data, nil, nil, nil)
                                }
                                observer.onNext(image)
                            } else {
                                observer.onNext(nil)
                            }
                            observer.onCompleted()
                        })
                        return Disposables.create()
                    }))
                }
            }
        }
        if observables.count == 0 {
            return nil
        }else {
            return Observable.zip(observables).rxSchedulerHelper()
        }
    }
    
    private func generateShareImage(_ save: Bool) -> Observable<UIImage?>? {
        if let fetch = fetchShareImages(save) {
            return fetch.map({ (shareImages) -> UIImage? in
                var renderer = UIGraphicsImageRenderer(size: self.generateZone.frame.size)
                var shareImage = renderer.image(actions: { (context) in
                    self.generateZone.layer.render(in: context.cgContext)
                })
                
                let width = self.view.frame.size.width
                var height = CGFloat(0)
                for shareImage in shareImages {
                    if let image = shareImage {
                        let radio = image.size.width / image.size.height
                        height += width / radio
                    }
                }
                let size = CGSize(width: width, height: height)
                var y = CGFloat(0)
                
                renderer = UIGraphicsImageRenderer(size: size)
                shareImage = renderer.image(actions: { (context) in
                    for shareImage in shareImages {
                        if let image = shareImage {
                            let radio = image.size.width / image.size.height
                            image.draw(in: CGRect(x: 0, y: y, width: width, height: width / radio))
                            y += width / radio
                        }
                    }
                    shareImage.draw(at: CGPoint(x: 0, y: y - shareImage.size.height))
                })
                
                if save {
                    UIImageWriteToSavedPhotosAlbum(shareImage, nil, nil, nil)
                }
                return shareImage
            })
        } else {
            return nil
        }
    }
    
}

extension ShareAppController: ELWaterFlowLayoutDelegate  {
    func el_flowLayout(_ flowLayout: ELWaterFlowLayout, heightForRowAt index: Int) -> CGFloat {
        return self.cache[index] ?? 0
    }
}
