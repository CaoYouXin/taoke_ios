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

class ShareController: UIViewController {
    
    var couponItem: CouponItem?
    
    @IBOutlet weak var selectCount: UILabel!
    
    @IBOutlet weak var shareImageList: UICollectionView!
    
    @IBOutlet weak var shareText: UITextView!
    
    @IBOutlet weak var saveIcon: UIImageView!
    
    @IBOutlet weak var saveText: UILabel!
    
    @IBOutlet weak var copyIcon: UIImageView!
    
    @IBOutlet weak var copyText: UILabel!
    
    private let disposeBag = DisposeBag()
    
    private var shareImages: [ShareImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize.init(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        
        navigationItem.title = "创建分享"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "分享", style: UIBarButtonItemStyle.plain, target: self, action: #selector(share))
        
        let text = "已选 1 张"
        let selectCountMutableAttributedString = NSMutableAttributedString(string: text)
        let location = text.index(of: " ")?.encodedOffset
        let range = NSRange(location: location!, length: text.utf16.count - location! - 1)
        selectCountMutableAttributedString.addAttribute(.foregroundColor, value: UIColor("#ef6c00"), range: range)
        selectCount.attributedText = selectCountMutableAttributedString
        
        let cloudDownloadIcon = FAKMaterialIcons.cloudDownloadIcon(withSize: 22)
        cloudDownloadIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#ef6c00"))
        saveIcon.image = cloudDownloadIcon!.image(with: CGSize.init(width: 22, height: 22))
        
        shareText.layer.borderWidth = 1
        shareText.layer.borderColor = UIColor("#bdbdbd").cgColor
        shareText.text = "\(couponItem!.title!)\n  【包邮】\n  【在售价】\(couponItem!.priceBefore!)元\n  【券后价】\(couponItem!.priceAfter!)元\n  【下单链接】{分享渠道后自动生成链接与口令}"
        
        let iosCopyIcon = FAKIonIcons.iosCopyIcon(withSize: 22)
        iosCopyIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#ef6c00"))
        copyIcon.image = iosCopyIcon!.image(with: CGSize.init(width: 22, height: 22))
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        saveIcon.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        saveText.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        copyIcon.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        copyText.addGestureRecognizer(tapGestureRecognizer)
        
        initShareImageList()
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
            cell.select.image = checkCircleIcon!.image(with: CGSize(width: 24, height: 24))
            return cell
        }
        
        let shareImageListDataSource = ShareImageDataSource(couponItem!)
        
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
            cell.select.image = checkCircleIcon!.image(with: CGSize(width: 24, height: 24))
            
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
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func share() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case saveIcon, saveText:
            var observables: [Observable<UIImage?>] = []
            if let shareImages = self.shareImages {
                for i in 0..<shareImages.count {
                    let shareImage = shareImages[i]
                    if shareImage.selected! {
                        observables.append(Observable.create({ (observer) -> Disposable in
                            KingfisherManager.shared.downloader.downloadImage(with: URL(string: shareImage.thumb!)!, retrieveImageTask: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, url, data) in
                                if let data = image {
                                    UIImageWriteToSavedPhotosAlbum(data, nil, nil, nil)
                                    observer.onNext(image)
                                    observer.onCompleted()
                                } else {
                                    observer.onError(error!)
                                }
                            })
                            return Disposables.create()
                        }))
                    }
                }
            }
            if observables.count != 0 {
                self.view.makeToastActivity(.center)
                Observable.zip(observables)
                    .rxSchedulerHelper()
                    .subscribe(onNext: { _ in
                        self.view.hideToastActivity()
                    }, onError: { (error) in
                        Log.error?.message(error.localizedDescription)
                    }).disposed(by: disposeBag)
            }
        case copyIcon, copyText:
            let linkHint = "{分享渠道后自动生成链接与口令}"
            let link = "\n\(couponItem!.thumb!)\n--------------------\n复制这条信息，\(couponItem!.thumb!.hashValue)，打开【手机淘宝】即可查看"
            if var text = shareText.text {
                if let _ = text.range(of: linkHint) {
                    text = text.replacingOccurrences(of: linkHint, with: link)
                } else {
                    text += link
                }
                let pasteboard = UIPasteboard.general
                pasteboard.string = text
            }
        default:
            break
        }
    }
}
