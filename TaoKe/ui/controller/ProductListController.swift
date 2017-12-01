
import CleanroomLogger
import RxSwift
import RxBus
import RxSegue
import FontAwesomeKit
import ELWaterFallLayout
import MJRefresh

class ProductListController: UIViewController {
    
    @IBOutlet weak var sortMultiple: UILabel!
    
    @IBOutlet weak var sortSales: UILabel!
    
    @IBOutlet weak var sortCommission: UILabel!
    
    @IBOutlet weak var sortPriceWrapper: UIView!
    
    @IBOutlet weak var sortPrice: UILabel!
    
    @IBOutlet weak var sortPriceUp: UIImageView!
    
    @IBOutlet weak var sortPriceDown: UIImageView!
    
    @IBOutlet weak var productList: UICollectionView!
    
    var homeBtn: HomeBtn?
    
    private var sort: Int = 0
    
    private var sizeCache: [String: CGSize] = [:]
    
    private let disposeBag = DisposeBag()
    
    private var productListHelper: MVCHelper<CouponItem>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        if homeBtn != nil {
            navigationItem.title = homeBtn!.name!
        }
        
        initSortBar()
        
        if homeBtn != nil {
            initProductList()
        }
    }
    
    private func initSortBar() {
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortMultiple.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortSales.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortCommission.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortPriceWrapper.addGestureRecognizer(tapGestureRecognizer)
        
        let chevronUpIcon = FAKFontAwesome.chevronUpIcon(withSize: 8)
        chevronUpIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#bdbdbd"))
        sortPriceUp.image = chevronUpIcon?.image(with: CGSize(width: 8, height: 8))
        
        let chevronDownIcon = FAKFontAwesome.chevronDownIcon(withSize: 8)
        chevronDownIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#bdbdbd"))
        sortPriceDown.image = chevronDownIcon?.image(with: CGSize(width: 8, height: 8))
    }
    
    @objc private func updateSortBar(_ sender: UITapGestureRecognizer) {
        let grey400 = UIColor("#bdbdbd")
        let grey900 = UIColor("#212121")
        sortMultiple.textColor = grey400
        sortSales.textColor = grey400
        sortCommission.textColor = grey400
        sortPrice.textColor = grey400
        
        let chevronUpIcon = FAKFontAwesome.chevronUpIcon(withSize: 8)
        chevronUpIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey400)
        sortPriceUp.image = chevronUpIcon?.image(with: CGSize(width: 8, height: 8))
        
        let chevronDownIcon = FAKFontAwesome.chevronDownIcon(withSize: 8)
        chevronDownIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey400)
        sortPriceDown.image = chevronDownIcon?.image(with: CGSize(width: 8, height: 8))
        
        switch sender.view! {
        case sortMultiple:
            sort = ProductDataSource.SORT_MULTIPLE
            sortMultiple.textColor = grey900
            break
        case sortSales:
            sort = ProductDataSource.SORT_SALES
            sortSales.textColor = grey900
            break
        case sortCommission:
            sort = ProductDataSource.SORT_COMMISSION
            sortCommission.textColor = grey900
            break
        default:
            sortPrice.textColor = grey900
            if sort == ProductDataSource.SORT_PRICE_UP {
                sort = ProductDataSource.SORT_PRICE_DOWN
                let chevronDownIcon = FAKFontAwesome.chevronDownIcon(withSize: 8)
                chevronDownIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey900)
                sortPriceDown.image = chevronDownIcon?.image(with: CGSize(width: 8, height: 8))
            } else {
                sort = ProductDataSource.SORT_PRICE_UP
                let chevronUpIcon = FAKFontAwesome.chevronUpIcon(withSize: 8)
                chevronUpIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey900)
                sortPriceUp.image = chevronUpIcon?.image(with: CGSize(width: 8, height: 8))
            }
            break
        }
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
            
            if element.couponInfo != nil {
                cell.priceBefore.attributedText = NSAttributedString(string: "¥ \(element.zkFinalPrice!)", attributes: [NSAttributedStringKey.strikethroughStyle: 1])
                cell.priceAfter.text = "¥ \(element.couponPrice!)"
                cell.volume.text = "月销\(element.volume!)笔"
                cell.couponInfo.text = "券 | \(element.couponInfo!)"
            } else {
                cell.price.text = "¥ \(element.zkFinalPrice!)"
                cell.sales.text = "月销\(element.volume!)笔"
            }
            
            if !(UserData.get()?.isBuyer())! {
                cell.earn.text = " 分享赚 ¥ \(element.earnPrice!)  "
                cell.earn.layer.cornerRadius = 8
                cell.earn.clipsToBounds = true
            }
            
            return cell
        }
        
        let productDataSource = ProductDataSource(viewController: self, homeBtn: homeBtn)
        
        productListHelper = MVCHelper<CouponItem>(productList)
        
        productListHelper?.set(cellFactory: productCellFactory)
        productListHelper?.set(dataSource: productDataSource)
        
        productListHelper?.refresh()
        
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
        
        productList.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.productListHelper?.loadMore()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.productList.mj_footer.isHidden = true
                self.productList.mj_footer.isHidden = false
            }
        })
        
        productList.mj_footer.isAutomaticallyHidden = false
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
