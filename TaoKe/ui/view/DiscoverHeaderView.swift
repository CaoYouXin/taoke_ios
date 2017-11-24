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
    
    private var brandListHelper: MVCHelper<HomeBtn>?
    private var controller: DiscoverController?
    
    public func setController(ctrl: DiscoverController) {
        self.controller = ctrl
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.maximumContentHeight = self.couponTab.frame.origin.y + self.couponTab.frame.size.height
        
        self.minimumContentHeight = self.couponTab.frame.size.height
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.maximumContentHeight)
        
        initSlider()
        initBrandList()
        initCouponTab()
    }
    
    public func refreshHeader() {
        updateSlider()
        updateBrandList()
        updateCouponTab()
    }
    
    private func initSlider() {
        slideshow.slideshowInterval = 3
        slideshow.contentScaleMode = .scaleAspectFill
        //slideshow.draggingEnabled = false
        
        updateSlider()
    }
    
    private func updateSlider() {
        let _ = TaoKeApi.getBannerList().rxSchedulerHelper().subscribe(onNext: { btns in
            var imageSources: [KingfisherSource] = [];
            for btn in btns! {
                imageSources.append(KingfisherSource(urlString: btn.imgUrl!)!)
            }
            self.slideshow.setImageInputs(imageSources)
        }, onError: { error in
            Log.error?.message(error.localizedDescription)
        })
    }
    
    private func initBrandList() {
        brandList.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let brandCellFactory: (UICollectionView, Int, HomeBtn) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BrandCell
            
            cell.thumb.layer.borderWidth = 1
            cell.thumb.layer.borderColor = UIColor.white.cgColor
            //cell.thumb.image = #imageLiteral(resourceName: "splash")
            cell.thumb.kf.setImage(with: URL(string: element.imgUrl!))
            return cell
        }
        
        let brandDataSource = BrandDataSource()
        
        let brandDataHook = { (brandItems: [HomeBtn]) -> [HomeBtn] in
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
        
        brandListHelper = MVCHelper<HomeBtn>(brandList)
        
        brandListHelper?.set(cellFactory: brandCellFactory)
        brandListHelper?.set(dataSource: brandDataSource)
        brandListHelper?.set(dataHook: brandDataHook)
        
        updateBrandList()
    }
    
    private func updateBrandList() {
        brandListHelper?.refresh()
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
                items.append(tab.name == nil ? "" : tab.name!)
            }
            self.couponTab.items = items
            
            if tabs.count == 0 {
                return
            }
            
            self.controller?.refreshCouponList(cid: tabs[0].cid!)
        }, onError: { error in
            Log.error?.message(error.localizedDescription)
        })
    }
}
