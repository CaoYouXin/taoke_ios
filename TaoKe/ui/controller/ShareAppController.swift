//
//  ShareAppController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/25.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import CleanroomLogger
import UIKit
import FontAwesomeKit
import RxSwift
import ELWaterFallLayout
import RxBus

class ShareAppController: UIViewController {

    @IBOutlet weak var generateZone: UIView!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var specification: UILabel!
    @IBOutlet weak var shareTemplateList: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private var cache: [Int: CGFloat] = [:];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        
        navigationItem.title = "分享给好友"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: UIBarButtonItemStyle.plain, target: self, action: #selector(share))
        
        initShareTemplates()
    }
    
    private func initShareTemplates() {
        let shareTemplateLayout = ELWaterFlowLayout()
        shareTemplateList.collectionViewLayout = shareTemplateLayout

        shareTemplateLayout.delegate = self
        shareTemplateLayout.lineCount = 1
        shareTemplateLayout.vItemSpace = 10//垂直间距10
        shareTemplateLayout.hItemSpace = 10//水平间距10
        shareTemplateLayout.edge = UIEdgeInsets.zero
        shareTemplateLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        //refresh layout
        RxBus.shared.asObservable(event: Events.WaterFallLayout.self)
            .throttle(RxTimeInterval(1), latest: true, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .rxSchedulerHelper()
            .subscribe { event in
                shareTemplateLayout.lineCount = 1
            }.disposed(by: disposeBag)
        
        let shareImageListCellFactory: (UICollectionView, Int, ShareImage) -> UICollectionViewCell = { (collectionView, row, element) in
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
        
        let shareImageListDataSource = ShareTemplateDataSource(viewController: self)
        shareImageListDataSource.selected = -1
        
        let shareImageListDataHook: ([ShareImage]) -> [ShareImage] = {
            shareImages in
            if shareImages.count > 0 && shareImageListDataSource.selected == -1 {
                shareImages[0].selected = true
            }
            return shareImages
        }
        
        let shareImageListHelper = MVCHelper<ShareImage>(shareTemplateList)
        
        shareImageListHelper.set(cellFactory: shareImageListCellFactory)
        shareImageListHelper.set(dataSource: shareImageListDataSource)
        shareImageListHelper.set(dataHook: shareImageListDataHook)
        
        shareImageListHelper.refresh()
        
        shareTemplateList.rx.itemSelected.subscribe(onNext: { indexPath in
            shareImageListDataSource.selected = indexPath.row
            shareImageListHelper.refresh()
        }, onError: { error in
            Log.error?.message(error.localizedDescription)
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func share() {
        navigationController?.popViewController(animated: true)
    }

}

extension ShareAppController: ELWaterFlowLayoutDelegate  {
    func el_flowLayout(_ flowLayout: ELWaterFlowLayout, heightForRowAt index: Int) -> CGFloat {
        print("set from cache or not = \(self.cache[index] ?? 0)")
        return self.cache[index] ?? 0
    }
}
