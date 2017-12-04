
import CleanroomLogger
import RxSwift
import RxBus
import ImageSlideshow
import TabLayoutView

class DiscoverHeaderView: GSKStretchyHeaderView {
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var brandList: UICollectionView!
    @IBOutlet weak var brandListFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var brandListHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var couponTab: TabLayoutView!
    
    private var brandListHelper: MVCHelper<HomeBtn>?
    private var controller: DiscoverController?
    private var sliders: [HomeBtn]?
    
    var maxContentHeight = CGFloat(0)
    var disposeBag = DisposeBag()
    
    public func setController(ctrl: DiscoverController) {
        self.controller = ctrl
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.maximumContentHeight = self.couponTab.frame.origin.y + self.couponTab.frame.size.height
        self.maxContentHeight += self.maximumContentHeight
        self.minimumContentHeight = self.couponTab.frame.size.height
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.maximumContentHeight)
        
        initSlider()
        initBrandList()
        initCouponTab()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        slideshow.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        if let slides = self.sliders {
            let btn = slides[slideshow.currentPage]
            let productListController = UIStoryboard(name: "ProductList", bundle: nil).instantiateViewController(withIdentifier: "ProductListController") as! ProductListController
            productListController.homeBtn = btn
            self.controller?.navigationController?.pushViewController(productListController, animated: true)
        }
    }
    
    public func refreshHeader() {
        updateSlider()
        updateBrandList()
        updateCouponTab()
    }
    
    private func initSlider() {
        slideshow.slideshowInterval = 3
        slideshow.contentScaleMode = .scaleAspectFill
        
        updateSlider()
    }
    
    private func updateSlider() {
        let _ = TaoKeApi.getBannerList().rxSchedulerHelper()
            .handleApiError(controller)
            .subscribe(onNext: { btns in
                self.sliders = btns
                var imageSources: [KingfisherSource] = [];
                for btn in btns! {
                    imageSources.append(KingfisherSource(urlString: btn.imgUrl!)!)
                }
                self.slideshow.setImageInputs(imageSources)
            })
    }
    
    private func initBrandList() {
        brandList.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        brandListFlowLayout.itemSize = CGSize(width: self.frame.size.width / 3, height: self.frame.size.width / 3)
        
        let brandCellFactory: (UICollectionView, Int, HomeBtn) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BrandCell
            
            cell.thumb.layer.borderWidth = 1
            cell.thumb.layer.borderColor = UIColor.white.cgColor
            cell.thumb.kf.setImage(with: URL(string: element.imgUrl!))
            return cell
        }
        
        let brandDataSource = BrandDataSource()
        
        let brandDataHook = { (brandItems: [HomeBtn]) -> [HomeBtn] in
            let height = (self.frame.size.width / 3) * CGFloat((brandItems.count / 3) + (brandItems.count % 3 > 0 ? 1 : 0))
            self.maximumContentHeight = self.maxContentHeight + height
            
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.maximumContentHeight)
            
            if self.brandListHeightConstraint.constant != height {
                self.brandListHeightConstraint.constant = height
            }
            
            RxBus.shared.post(event: Events.ViewDidLoad())
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
        TaoKeApi.getCouponTab()
            .rxSchedulerHelper()
            .handleApiError(controller, nil)
            .subscribe(onNext: { tabs in
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
            }).disposed(by: disposeBag)
    }
}
