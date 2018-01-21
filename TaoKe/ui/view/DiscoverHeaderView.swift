
import CleanroomLogger
import RxSwift
import RxBus
import ImageSlideshow
import TabLayoutView
import ADMozaicCollectionViewLayout

class DiscoverHeaderView: GSKStretchyHeaderView {
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var brandList: UICollectionView!
    @IBOutlet weak var brandListHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var couponTab: TabLayoutView!
    
    private var brandListHelper: MVCHelper<AdZoneItem>?
    private var controller: DiscoverController?
    private var sliders: [HomeBtn]?
    
    var maxContentHeight = CGFloat(0)
    private let disposeBag = DisposeBag()
    
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
        
        let adMozaikLayout = ADMozaikLayout(delegate: self)
        brandList.collectionViewLayout = adMozaikLayout
        
        let brandCellFactory: (UICollectionView, Int, AdZoneItem) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BrandCell
            
//            cell.thumb.layer.borderWidth = 1
//            cell.thumb.layer.borderColor = UIColor.white.cgColor
            cell.thumb.kf.setImage(with: URL(string: element.thumb!))
            
            return cell
        }
        
        brandListHelper = MVCHelper<AdZoneItem>(brandList)
        brandListHelper?.set(cellFactory: brandCellFactory)
        brandListHelper?.set(dataSource: BrandDataSource())
        brandListHelper?.set(dataHook: { (data) -> [AdZoneItem] in
            var map:[Int:Int] = [:]
            var min = 1, max = 0
            for item in data {
                while true {
                    if nil == map[min] {
                        for r in 1...item.rSpan! {
                            map[min + r - 1] = 60 - item.cSpan!
                        }
                        if max < min + item.rSpan! - 1 {
                            max = min + item.rSpan! - 1
                        }
                        break
                    }
                    
                    if map[min]! >= item.cSpan! {
                        for r in 1...item.rSpan! {
                            if nil == map[min + r - 1] {
                                map[min + r - 1] = 60
                            }
                            map[min + r - 1] = map[min + r - 1]! - item.cSpan!
                        }
                        if max < min + item.rSpan! - 1 {
                            max = min + item.rSpan! - 1
                        }
                        break
                    }
                    
                    min += 1
                }
            }
            
            let height = CGFloat(max) * self.brandList.frame.size.width / 60
            if self.brandListHeightConstraint.constant != height {
                self.brandListHeightConstraint.constant = height
                self.maximumContentHeight = self.maxContentHeight + self.brandListHeightConstraint.constant
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.maximumContentHeight)
                RxBus.shared.post(event: Events.ViewDidLoad())
            }

            return data
        })
        
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

extension DiscoverHeaderView: ADMozaikLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, mozaik layout: ADMozaikLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize {
        do {
            let model = try collectionView.rx.model(at: indexPath) as AdZoneItem
            return ADMozaikLayoutSize(numberOfColumns: model.cSpan!, numberOfRows: model.rSpan!)
        }catch {
            Log.error?.message(error.localizedDescription)
        }
        return ADMozaikLayoutSize(numberOfColumns: 60, numberOfRows: 1)
    }
    
    func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo {
        let unitOne = collectionView.frame.size.width / 60
        var columns: [ADMozaikLayoutColumn] = []
        for _ in 1...60 {
            columns.append(ADMozaikLayoutColumn(width: unitOne))
        }
        return ADMozaikLayoutSectionGeometryInfo(rowHeight: unitOne, columns: columns)
    }
}
