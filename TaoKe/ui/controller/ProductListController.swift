
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
    var disposeBag = DisposeBag()
    
    private var sortHelper: SortHelper?
    private var sizeCache: [String: CGSize] = [:]
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
        
        if (UserData.get()?.isBuyer())! {
            sortCommissionWrapper.isHidden = true
        }
        
        barClicked(on: sortSales)
    }
    
    @objc private func updateSortBar(_ sender: UITapGestureRecognizer) {
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
            
            cell.title.text = element.title
            
            if element.couponInfo != nil {
                cell.coupon.isHidden = false
                cell.couponHeight.constant = 30
                cell.priceAfter.isHidden = false
                cell.priceBefore.isHidden = false
                cell.couponSales.isHidden = false
                cell.noCouponHeight.constant = 0
                cell.price.isHidden = true
                cell.sales.isHidden = true
                
                cell.priceBefore.attributedText = NSAttributedString(string: "¥ \(element.zkFinalPrice!)", attributes: [NSAttributedStringKey.strikethroughStyle: 1])
                cell.priceAfter.text = "¥ \(element.couponPrice!)"
                cell.couponSales.text = "销\(element.volume!)"
                
                var start = element.couponInfo?.index(of: "减")
                start = element.couponInfo?.index(after: start!)
                let coupon = element.couponInfo?[start!...]
                cell.coupon.text = " 券 \(coupon!)  "
                cell.coupon.sizeToFit()
                
                let arc = UIBezierPath()
                arc.move(to: CGPoint(x: 0, y: 0))
                arc.addLine(to: CGPoint(x: cell.coupon.frame.size.width, y: 0))
                arc.addLine(to: CGPoint(x: cell.coupon.frame.size.width, y: cell.coupon.frame.size.height / 4))
                arc.addArc(withCenter: CGPoint(x: cell.coupon.frame.size.width, y: cell.coupon.frame.size.height / 2), radius: cell.coupon.frame.size.height / 4, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2), clockwise: false)
                arc.addLine(to: CGPoint(x: cell.coupon.frame.size.width, y: cell.coupon.frame.size.height))
                arc.addLine(to: CGPoint(x: 0, y: cell.coupon.frame.size.height))
                arc.addLine(to: CGPoint(x: 0, y: cell.coupon.frame.size.height*3/4))
                arc.addArc(withCenter: CGPoint(x: 0, y: cell.coupon.frame.size.height / 2), radius: cell.coupon.frame.size.height / 4, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(-Double.pi/2), clockwise: false)
                arc.close()
                let arcLayer = CAShapeLayer()
                arcLayer.path = arc.cgPath
                cell.coupon.layer.mask = arcLayer
            } else {
                cell.coupon.isHidden = true
                cell.couponHeight.constant = 0
                cell.priceAfter.isHidden = true
                cell.priceBefore.isHidden = true
                cell.couponSales.isHidden = true
                cell.noCouponHeight.constant = 30
                cell.price.isHidden = false
                cell.sales.isHidden = false
                
                cell.price.text = "¥ \(element.zkFinalPrice!)"
                cell.sales.text = "销\(element.volume!)"
            }
            
            if !(UserData.get()?.isBuyer())! {
                cell.earn.isHidden = false
                
                cell.earn.text = " 赚 ¥\(element.earnPrice!)  "
                cell.earn.layer.cornerRadius = 8
                cell.earn.clipsToBounds = true
            } else {
                cell.earn.isHidden = true
            }
            
            cell.blockHeight.constant = element.couponInfo != nil || !(UserData.get()?.isBuyer())! ? 30 : 0
            
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
        customFooter?.setTitle("我们是有底线的！😊", for: .pulling)
        customFooter?.setTitle("我们是有底线的！😊", for: .refreshing)
        
        productList.mj_footer = customFooter
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
