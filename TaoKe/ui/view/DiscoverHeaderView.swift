//
//  DiscoverHeaderView.swift
//  TaoKe
//
//  Created by jason tsang on 11/9/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import CleanroomLogger
import RxSwift
import RxBus
import ImageSlideshow
import TabLayoutView

class DiscoverHeaderView: GSKStretchyHeaderView {
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    @IBOutlet weak var brandList: UICollectionView!
    @IBOutlet weak var brandListFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var couponTab: TabLayoutView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.maximumContentHeight = self.couponTab.frame.origin.y + self.couponTab.frame.size.height
        
        self.minimumContentHeight = self.couponTab.frame.size.height
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.maximumContentHeight)
        
        initSlider()
        initBrandList()
        initCouponTab()
    }
    
    private func initSlider() {
        slideshow.slideshowInterval = 3
        slideshow.contentScaleMode = .scaleAspectFill
        //slideshow.draggingEnabled = false
        
        updateSlider()
    }
    
    private func updateSlider() {
        slideshow.setImageInputs([
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!)
            //            KingfisherSource(urlString: "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg")!
            ])
    }
    
    private func initBrandList() {
        brandList.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let brandCellFactory: (UICollectionView, Int, BrandItem) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BrandCell
            
            cell.thumb.layer.borderWidth = 1
            cell.thumb.layer.borderColor = UIColor.white.cgColor
            //cell.thumb.image = #imageLiteral(resourceName: "splash")
            cell.thumb.kf.setImage(with: URL(string: element.thumb!))
            return cell
        }
        
        let brandDataSource = BrandDataSource()
        
        let brandDataHook = { (brandItems: [BrandItem]) -> [BrandItem] in
            if let constraint = (self.brandList.constraints.filter{$0.firstAttribute == .height}.first) {
                let height = (self.frame.size.width / 3) * CGFloat((brandItems.count / 3) + (brandItems.count % 3 > 0 ? 1 : 0))
                constraint.constant = height
                
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height + height)
                
                self.maximumContentHeight += height
                
                self.brandListFlowLayout.itemSize = CGSize(width: self.frame.size.width / 3, height: self.frame.size.width / 3)
                
                //fix the content offset bug, any better way?
                RxBus.shared.post(event: Events.ViewDidLoad())
            }
            return brandItems
        }
        
        let brandListHelper = MVCHelper<BrandItem>(brandList)
        
        brandListHelper.set(cellFactory: brandCellFactory)
        brandListHelper.set(dataSource: brandDataSource)
        brandListHelper.set(dataHook: brandDataHook)
        
        brandListHelper.refresh()
    }
    
    private func initCouponTab() {
        couponTab.indicatorColor = UIColor("#ef6c00")
        couponTab.fontSelectedColor = UIColor("#ef6c00")
        
        couponTab.layer.shadowColor = UIColor.black.cgColor
        couponTab.layer.shadowOffset = CGSize(width: 0, height: 4)
        couponTab.layer.shadowOpacity = 0.2;
        
        updateCouponTab()
    }
    
    private func updateCouponTab() {
        let _ = TaoKeApi.getCouponTab().rxSchedulerHelper().subscribe(onNext: { tabs in
            var items: [String] = []
            for tab in tabs {
                items.append(tab.title == nil ? "" : tab.title!)
            }
            self.couponTab.items = items
        }, onError: { error in
            Log.error?.message(error.localizedDescription)
        })
    }
}
