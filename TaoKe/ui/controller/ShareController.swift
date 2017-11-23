//
//  ShareController.swift
//  TaoKe
//
//  Created by jason tsang on 11/16/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import CleanroomLogger
import RxSwift
import RxCocoa
import FontAwesomeKit
import Kingfisher
import Toast_Swift
import QRCode

class ShareController: UIViewController {
    
    var couponItem: CouponItem?
    
    @IBOutlet weak var selectCount: UILabel!
    
    @IBOutlet weak var shareImageList: UICollectionView!
    
    @IBOutlet weak var shareText: UITextView!
    
    @IBOutlet weak var saveIcon: UIImageView!
    
    @IBOutlet weak var saveText: UILabel!
    
    @IBOutlet weak var copyIcon: UIImageView!
    
    @IBOutlet weak var copyText: UILabel!
    
    @IBOutlet weak var wechatWrapper: UIView!
    @IBOutlet weak var wechatIcon: UIImageView!
    
    @IBOutlet weak var weiboWrapper: UIView!
    @IBOutlet weak var weiboIcon: UIImageView!
    
    @IBOutlet weak var qqWrapper: UIView!
    @IBOutlet weak var qqIcon: UIImageView!
    
    @IBOutlet weak var descWrapper: UIView!
    @IBOutlet weak var descTitle: UILabel!
    @IBOutlet weak var descPriceBefore: UILabel!
    @IBOutlet weak var descCoupon: UILabel!
    @IBOutlet weak var descPriceAfter: UILabel!
    @IBOutlet weak var descQRCode: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    private var shareImages: [ShareImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        
        navigationItem.title = "创建分享"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.plain, target: self, action: #selector(share))
        
        let text = "已选 1 张"
        let selectCountMutableAttributedString = NSMutableAttributedString(string: text)
        let location = text.index(of: " ")?.encodedOffset
        let range = NSRange(location: location!, length: text.utf16.count - location! - 1)
        selectCountMutableAttributedString.addAttribute(.foregroundColor, value: UIColor("#ef6c00"), range: range)
        selectCount.attributedText = selectCountMutableAttributedString
        
        let cloudDownloadIcon = FAKMaterialIcons.cloudDownloadIcon(withSize: 22)
        cloudDownloadIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#ef6c00"))
        saveIcon.image = cloudDownloadIcon?.image(with: CGSize(width: 22, height: 22))
        
        shareText.layer.borderWidth = 1
        shareText.layer.borderColor = UIColor("#bdbdbd").cgColor
        shareText.text = "\(couponItem!.title!)\n  【包邮】\n  【在售价】\(couponItem!.zkFinalPrice!)元\n  【券后价】\(couponItem!.couponPrice!)元\n  【下单链接】{分享渠道后自动生成链接与口令}"
        
        let iosCopyIcon = FAKIonIcons.iosCopyIcon(withSize: 22)
        iosCopyIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#ef6c00"))
        copyIcon.image = iosCopyIcon?.image(with: CGSize(width: 22, height: 22))
        
        let wechatIcon = FAKFontAwesome.wechatIcon(withSize: 35)
        wechatIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#04cd0d"))
        self.wechatIcon.image = wechatIcon?.image(with: CGSize(width: 40, height: 40))
        
        let weiboIcon = FAKFontAwesome.weiboIcon(withSize: 35)
        weiboIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#d14220"))
        self.weiboIcon.image = weiboIcon?.image(with: CGSize(width: 40, height: 40))
        
        let qqIcon = FAKFontAwesome.qqIcon(withSize: 35)
        qqIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#39afed"))
        self.qqIcon.image = qqIcon?.image(with: CGSize(width: 40, height: 40))
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        saveIcon.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        saveText.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        copyIcon.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        copyText.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        wechatWrapper.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        weiboWrapper.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        qqWrapper.addGestureRecognizer(tapGestureRecognizer)
        initShareImageList()
        
        initDesc()
    }
    
    private func initShareImageList() {
        let shareImageListCellFactory: (UICollectionView, Int, ShareImage) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShareImageCell
            cell.thumb.layer.borderWidth = 1
            cell.thumb.layer.borderColor = UIColor("#bdbdbd").cgColor
            cell.thumb.kf.setImage(with: URL(string: element.thumb!))
            
            let checkCircleIcon = FAKFontAwesome.checkCircleIcon(withSize: 24)
            checkCircleIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor(element.selected! ? "#e65100" : "#00000080"))
            cell.select.image = checkCircleIcon?.image(with: CGSize(width: 24, height: 24))
            return cell
        }
        
        let shareImageListDataSource = ShareImageDataSource(viewController: self, couponItem: couponItem)
        
        let shareImageListDataHook: ([ShareImage]) -> [ShareImage] = {
            shareImages in
            shareImages[0].selected = true
            self.shareImages = shareImages
            return shareImages
        }
        
        let shareImageListHelper = MVCHelper<ShareImage>(shareImageList)
        
        shareImageListHelper.set(cellFactory: shareImageListCellFactory)
        shareImageListHelper.set(dataSource: shareImageListDataSource)
        shareImageListHelper.set(dataHook: shareImageListDataHook)
        
        shareImageListHelper.refresh()
        
        shareImageList.rx.itemSelected.subscribe(onNext: { indexPath in
            let cell = self.shareImageList.cellForItem(at: indexPath) as! ShareImageCell
            
            let checkCircleIcon = FAKFontAwesome.checkCircleIcon(withSize: 24)
            do{
                let model = try self.shareImageList.rx.model(at: indexPath) as ShareImage
                model.selected = !model.selected!
                checkCircleIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor(model.selected! ? "#e65100" : "#00000080"))
            }catch {
                Log.error?.message(error.localizedDescription)
            }
            cell.select.image = checkCircleIcon?.image(with: CGSize(width: 24, height: 24))
            
            var selectCount = 0
            for shareImage in self.shareImages! {
                if shareImage.selected! {
                    selectCount = selectCount + 1
                }
            }
            let text = "已选 \(selectCount) 张"
            let selectCountMutableAttributedString = NSMutableAttributedString(string: text)
            let location = text.index(of: " ")?.encodedOffset
            let range = NSRange(location: location!, length: text.utf16.count - location! - 1)
            selectCountMutableAttributedString.addAttribute(.foregroundColor, value: UIColor("#ef6c00"), range: range)
            self.selectCount.attributedText = selectCountMutableAttributedString
        }, onError: { error in
            Log.error?.message(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    private func initDesc() {
        descTitle.text = couponItem!.title!
        
        var text = "现价  ¥ \(couponItem!.zkFinalPrice!)"
        var location = text.index(of: "¥")!.encodedOffset + 2
        var range = NSRange(location: location, length: text.utf16.count - location)
        var attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSUnderlineStyle.patternSolid.rawValue | NSUnderlineStyle.styleSingle.rawValue, range: range)
        descPriceBefore.attributedText = attributedText
        
        let orange800 = UIColor("#ef6c00")
        text = " 券  \(couponItem!.couponInfo!)"
        range = NSRange(location: 0, length: 3)
        attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedStringKey.backgroundColor, value: orange800, range: range)
        range = NSRange(location: 1, length: 1)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: range)
        range = NSRange(location: 4, length: text.utf16.count - 5)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: orange800, range: range)
        descCoupon.attributedText = attributedText
        descCoupon.layer.borderWidth = 1
        descCoupon.layer.borderColor = orange800.cgColor
        descCoupon.layer.cornerRadius = 2
        
        text = "券后价 ¥ \(couponItem!.couponPrice!)"
        attributedText = NSMutableAttributedString(string: text)
        location = text.index(of: "¥")!.encodedOffset
        range = NSRange(location: location, length: text.utf16.count - location)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: orange800, range: range)
        location = text.index(of: "¥")!.encodedOffset + 1
        range = NSRange(location: location, length: text.utf16.count - location)
        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18), range: range)
        descPriceAfter.attributedText = attributedText
        
        var qrCode = QRCode(couponItem!.couponClickUrl!)
        qrCode?.size = CGSize(width: descQRCode.frame.size.width - 6, height: descQRCode.frame.size.height - 6)
        descQRCode.image = qrCode?.image
    }
    
    private func fetchShareImages(_ save: Bool) -> Observable<[UIImage?]>? {
        var observables: [Observable<UIImage?>] = []
        if let shareImages = self.shareImages {
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
                var renderer = UIGraphicsImageRenderer(size: self.descWrapper.frame.size)
                var shareImage = renderer.image(actions: { (context) in
                    self.descWrapper.layer.render(in: context.cgContext)
                })
                
                let width = self.view.frame.size.width
                var height = shareImage.size.height
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
                    shareImage.draw(at: CGPoint(x: 0, y: y))
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
    
    private func generateShareText() -> String? {
        if var text = self.shareText.text {
            let linkHint = "{分享渠道后自动生成链接与口令}"
            let link = "\n\(self.couponItem!.itemUrl!)\n--------------------\n复制这条信息，\(self.couponItem!.itemUrl!.hashValue)，打开【手机淘宝】即可查看"
            if let _ = text.range(of: linkHint) {
                text = text.replacingOccurrences(of: linkHint, with: link)
            } else {
                text += link
            }
            return text
        }else {
            return nil
        }
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func share() {
        var actvityItems:[Any] = []
        
        let share = {
            if let shareText = self.generateShareText() {
                actvityItems.append(shareText)
            }
            
            let activityViewController = UIActivityViewController(activityItems: actvityItems, applicationActivities: nil)
            self.present(activityViewController, animated: true)
        }
        
        if let generateShareImage = generateShareImage(false) {
            self.view.makeToastActivity(.center)
            generateShareImage.subscribe(onNext: { shareImage in
                self.view.hideToastActivity()
                if let image = shareImage {
                    actvityItems.append(image)
                }
                share()
            }, onError: { (error) in
                self.view.hideToastActivity()
                share()
                Log.error?.message(error.localizedDescription)
            }).disposed(by: disposeBag)
        } else {
            share()
        }
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case saveIcon, saveText:
            if let fetch = fetchShareImages(true) {
                self.view.makeToastActivity(.center)
                fetch.subscribe(onNext: { _ in
                        self.view.hideToastActivity()
                    }, onError: { (error) in
                        self.view.hideToastActivity()
                        Log.error?.message(error.localizedDescription)
                    }).disposed(by: disposeBag)
            }
        case copyIcon, copyText:
            if let shareText = generateShareText() {
                let pasteboard = UIPasteboard.general
                pasteboard.string = shareText
            }
        case wechatWrapper, weiboWrapper, qqWrapper:
            let share = {
                if let shareText = self.generateShareText() {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = shareText
                }
                let alert = UIAlertController(title: "", message: "『照片已保存相册，文案已复制到粘贴板』", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "分享", style: .default, handler: { (action) in
                    var url: URL?
                    switch sender.view! {
                    case self.wechatWrapper:
                        url = URL(string: "wx60b7e2af0fe4c38c://weixin")
                    case self.weiboWrapper:
                        url = URL(string: "wx60b7e2af0fe4c38c://weixin")
                    case self.qqWrapper:
                        url = URL(string: "wx60b7e2af0fe4c38c://weixin")
                    default:
                        break
                    }
                    if url != nil {
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!, options: [:])
                        }
                    }
                }))
                self.present(alert, animated: true)
            }

            if let generateShareImage = generateShareImage(true) {
                self.view.makeToastActivity(.center)
                generateShareImage.subscribe(onNext: { _ in
                    self.view.hideToastActivity()
                    share()
                }, onError: { (error) in
                    self.view.hideToastActivity()
                    share()
                    Log.error?.message(error.localizedDescription)
                }).disposed(by: disposeBag)
            } else {
                share()
            }
        default:
            break
        }
    }
}
