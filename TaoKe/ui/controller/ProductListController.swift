
import CleanroomLogger
import RxSwift
import RxBus
import RxSegue
import FontAwesomeKit
import ELWaterFallLayout
import MJRefresh

class ProductListController: UIViewController {
    
    @IBOutlet weak var sortSales: UILabel!
    
    @IBOutlet weak var sortCommissionWrapper: UIView!
    @IBOutlet weak var sortCommission: UILabel!
    @IBOutlet weak var sortCommissionUp: UIImageView!
    @IBOutlet weak var sortCommissionDown: UIImageView!
    
    @IBOutlet weak var sortCouponWrapper: UIView!
    @IBOutlet weak var sortCoupon: UILabel!
    @IBOutlet weak var sortCouponUp: UIImageView!
    @IBOutlet weak var sortCouponDown: UIImageView!
    
    @IBOutlet weak var sortPriceWrapper: UIView!
    @IBOutlet weak var sortPrice: UILabel!
    @IBOutlet weak var sortPriceUp: UIImageView!
    @IBOutlet weak var sortPriceDown: UIImageView!
    
    @IBOutlet weak var productList: UICollectionView!
    
    var homeBtn: HomeBtn?
    
    private var sortHelper: SortHelper?
    
    private var sizeCache: [String: CGSize] = [:]
    
    private let disposeBag = DisposeBag()
    
    private var productListHelper: MVCHelper<CouponItem>?
    private var productDataSource: ProductDataSource?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        if homeBtn != nil {
            navigationItem.title = homeBtn!.name!
            initProductList()
            initSortBar()
        }
    }
    
    private func initSortBar() {
        print("debug = \(sortCommissionWrapper.restorationIdentifier!)")
        print("debug = \(sortCouponWrapper.restorationIdentifier!)")
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortSales.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortCommissionWrapper.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortCouponWrapper.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortPriceWrapper.addGestureRecognizer(tapGestureRecognizer)
        
        sortHelper = SortHelper()
        sortHelper?.setup(id: sortSales.restorationIdentifier!, main: sortSales, directions: nil, types: [.sales, .sales], flag: false)
        sortHelper?.setup(id: sortCommissionWrapper.restorationIdentifier!, main: sortCommission, directions: [sortCommissionUp, sortCommissionDown], types: [.commissionUp, .commissionDown], flag: true)
        sortHelper?.setup(id: sortCouponWrapper.restorationIdentifier!, main: sortCoupon, directions: [sortCouponUp, sortCouponDown], types: [.couponUp, .couponDown], flag: true)
        sortHelper?.setup(id: sortPriceWrapper.restorationIdentifier!, main: sortPrice, directions: [sortPriceUp, sortPriceDown], types: [.priceUp, .priceDown], flag: false)
        
        barClicked(on: sortSales)
    }
    
    @objc private func updateSortBar(_ sender: UITapGestureRecognizer) {
        print(sender.view?.restorationIdentifier)
        barClicked(on: sender.view!)
    }
    
    private func barClicked(on: UIView) {
        productDataSource?.sortBy = sortHelper?.calcSortBy(clickOn: on.restorationIdentifier!)
        productListHelper?.refresh()
    }
    
    private func initProductList() {
        productList.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let productListLayout = ELWaterFlowLayout()
        productList.collectionViewLayout = productListLayout
        
        productListLayout.delegate = self
        productListLayout.lineCount = 2
        productListLayout.vItemSpace = 10
        productListLayout.hItemSpace = 10
        productListLayout.edge = UIEdgeInsets.zero
        
        RxBus.shared.asObservable(event: Events.WaterFallLayout.self)
            .throttle(RxTimeInterval(1), latest: true, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .rxSchedulerHelper()
            .subscribe { event in
                productListLayout.lineCount = 2
            }.disposed(by: disposeBag)
        
        let productCellFactory: (UICollectionView, Int, CouponItem) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCell
            cell.thumb.kf.setImage(with: URL(string: element.pictUrl!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if let tmp = image {
                    self.sizeCache[element.pictUrl!] = tmp.size
                }
                RxBus.shared.post(event: Events.WaterFallLayout())
            })
            
            if element.couponInfo != nil {
                cell.noCouponWrapper.isHidden = true
                cell.couponWrapper.isHidden = false
                cell.couponInfo.isHidden = false
                
                cell.priceBefore.attributedText = NSAttributedString(string: "¥ \(element.zkFinalPrice!)", attributes: [NSAttributedStringKey.strikethroughStyle: 1])
                cell.priceAfter.text = "¥ \(element.couponPrice!)"
                cell.volume.text = "月销\(element.volume!)笔"
                cell.couponInfo.text = "券 | \(element.couponInfo!)"
            } else {
                cell.noCouponWrapper.isHidden = false
                cell.couponWrapper.isHidden = true
                cell.couponInfo.isHidden = true
                
                cell.price.text = "¥ \(element.zkFinalPrice!)"
                cell.sales.text = "月销\(element.volume!)笔"
            }
            
            if !(UserData.get()?.isBuyer())! {
                cell.earnWrapper.isHidden = false
                
                cell.earn.text = " 分享赚 ¥ \(element.earnPrice!)  "
                cell.earn.layer.cornerRadius = 8
                cell.earn.clipsToBounds = true
            } else {
                cell.earnWrapper.isHidden = true
            }
            
            if let constraint = (cell.noCouponWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
                constraint.constant = element.couponInfo == nil ? 30 : 0
            }
            
            if let constraint = (cell.couponWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
                constraint.constant = element.couponInfo == nil ? 0 : 60
            }
            
            if let constraint = (cell.earnWrapper.constraints.filter({$0.firstAttribute == .height}).first) {
                constraint.constant = (UserData.get()?.isBuyer())! ? 0 : 25
            }
            
            cell.title.text = element.title
            
            return cell
        }
        
        productDataSource = ProductDataSource(viewController: self, homeBtn: homeBtn)
        
        productListHelper = MVCHelper<CouponItem>(productList)
        
        productListHelper?.set(cellFactory: productCellFactory)
        productListHelper?.set(dataSource: productDataSource)
        
        let segue: AnyObserver<CouponItem> = NavigationSegue(
            fromViewController: self.navigationController!,
            toViewControllerFactory:
            { (sender, context) -> DetailController in
                let detailController = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
                detailController.couponItem = context
                return detailController
        }).asObserver()
        
        productList.rx.itemSelected
            .map{ indexPath -> CouponItem in
                return try self.productList.rx.model(at: indexPath)
            }
            .bind(to: segue)
            .disposed(by: disposeBag)
        
        productList.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.productListHelper?.refresh()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.productList.mj_header.endRefreshing()
            }
        })
        
        let customFooter = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.productList.mj_footer.endRefreshingWithNoMoreData()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.productList.mj_footer.resetNoMoreData()
            }
        })
        customFooter?.setTitle("我们是有底线的！😊", for: .noMoreData)
        customFooter?.setTitle("我们是有底线的！😊", for: .idle)
        customFooter?.setTitle("我们是有底线的！😊", for: .pulling)
        customFooter?.setTitle("我们是有底线的！😊", for: .refreshing)
        customFooter?.setTitle("我们是有底线的！😊", for: .willRefresh)
        productList.mj_footer = customFooter
        
        productList.mj_footer.isAutomaticallyHidden = true
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProductListController: ELWaterFlowLayoutDelegate  {
    func el_flowLayout(_ flowLayout: ELWaterFlowLayout, heightForRowAt index: Int) -> CGFloat {
        var cell: ProductCell?
        
        if productList.numberOfItems(inSection: 0) > index {
            cell = productList.cellForItem(at: IndexPath(row: index, section: 0)) as? ProductCell
        }
        
        var itemHeight: CGFloat = 50
        
        var imageSize: CGSize?
        
        do{
            let model = try productList.rx.model(at: IndexPath(row: index, section: 0)) as CouponItem
            
            if model.couponInfo == nil {
                itemHeight += 30
            } else {
                itemHeight += 60
            }
            
            if !(UserData.get()?.isBuyer())! {
                itemHeight += 25
            }
            
            imageSize = sizeCache[model.pictUrl!]
        }catch {
            Log.error?.message(error.localizedDescription)
        }
        
        if let size = imageSize {
            let radio = size.width / size.height
            itemHeight += (view.frame.size.width - 10) / 2 / radio
        }else if let image = cell?.thumb.image {
            let radio = image.size.width / image.size.height
            itemHeight += (view.frame.size.width - 10) / 2 / radio
        } else {
            itemHeight += (view.frame.size.width - 10) / 2
        }
        
        return itemHeight
    }
}
