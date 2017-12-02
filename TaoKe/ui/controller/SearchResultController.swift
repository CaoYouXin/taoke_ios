
import UIKit
import RxSwift
import RxSegue
import MJRefresh

class SearchResultController: UIViewController {

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
    
    @IBOutlet weak var itemList: UICollectionView!
    @IBOutlet weak var itemListLayout: UICollectionViewFlowLayout!
    
    private var sortHelper: SortHelper?
    private var itemListHelper: MVCHelper<CouponItem>?
    private var itemDataSource: SearchDataSource?
    private var setClickHandler = false
    private var disposeBag = DisposeBag()
    private var navigationControllerHolder: UINavigationController?
    private var isJu: Bool?
    private var keyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initItemList()
        initSortBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        itemDataSource?.sortBy = sortHelper?.calcSortBy(clickOn: on.restorationIdentifier!)
        itemListHelper?.refresh()
    }
    
    private func initItemList() {
        itemList.register(UINib(nibName: "CouponCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        itemListLayout.itemSize = CGSize(width: view.frame.size.width, height: 112)
        
        let couponCellFactory: (UICollectionView, Int, CouponItem) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CouponCell
            
            cell.thumb.kf.setImage(with: URL(string: element.pictUrl!))
            cell.couponTitle.text = element.title!
            cell.couponPriceBefore.text = "现价 ¥ \(element.zkFinalPrice!)"
            
            var couponPriceAfter: String
            if element.commissionRate == nil {
                cell.volume.isHidden = true
                couponPriceAfter = "聚划算价 ¥ \(element.couponPrice!)"
            } else {
                cell.volume.isHidden = false
                cell.volume.text = "月销 \(element.volume!) 件"
                couponPriceAfter = "券后价 ¥ \(element.couponPrice!)"
            }
            let couponPriceAfterMutableAttributed = NSMutableAttributedString(string: couponPriceAfter)
            let location = couponPriceAfter.index(of: "¥")?.encodedOffset
            let range = NSRange(location: location!, length: couponPriceAfter.utf16.count - location!)
            couponPriceAfterMutableAttributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
            couponPriceAfterMutableAttributed.addAttribute(.foregroundColor, value: UIColor.black, range: range)
            cell.couponPriceAfter.attributedText = couponPriceAfterMutableAttributed
            
            if let remain = element.couponRemainCount, let total = element.couponTotalCount {
                cell.couponProgress.isHidden = false
                let progress = Float(remain) / Float(total)
                if cell.couponProgress.progress != progress {
                    cell.couponProgress.progress = 0
                    cell.couponProgress.layoutIfNeeded()
                }
                cell.couponProgress.progress = progress
                UIView.animate(withDuration: 1, animations: { () -> Void in
                    cell.couponProgress.layoutIfNeeded()
                })
            } else {
                cell.couponProgress.isHidden = true
            }
            
            if element.couponInfo == nil {
                cell.couponValue.isHidden = true
            } else {
                cell.couponValue.isHidden = false
                cell.couponValue.text = "券 | \(element.couponInfo!)"
            }
            
            if !(UserData.get()?.isBuyer())!, let earn = element.earnPrice {
                cell.couponEarn.isHidden = false
                cell.couponEarn.text = "赚 ¥ \(earn)"
            } else {
                cell.couponEarn.isHidden = true
            }
            
            if let constraint = (cell.couponEarn.constraints.filter({$0.firstAttribute == .height}).first) {
                constraint.constant = (UserData.get()?.isBuyer())! || element.earnPrice == nil ? 0 : 15
            }
            return cell
        }
        
        itemListHelper = MVCHelper(itemList)
        itemListHelper?.set(cellFactory: couponCellFactory)
        
        itemDataSource = SearchDataSource(self)
        itemDataSource?.cache = nil
        itemDataSource?.keyword = keyword
        itemDataSource?.isJu = isJu
        itemListHelper?.set(dataSource: itemDataSource)
        
        let customFooter = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.itemList.mj_footer.endRefreshingWithNoMoreData()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.itemList.mj_footer.resetNoMoreData()
            }
        })
        customFooter?.setTitle("我们是有底线的！😊", for: .noMoreData)
        customFooter?.setTitle("我们是有底线的！😊", for: .idle)
        customFooter?.setTitle("我们是有底线的！😊", for: .pulling)
        customFooter?.setTitle("我们是有底线的！😊", for: .refreshing)
        customFooter?.setTitle("我们是有底线的！😊", for: .willRefresh)
        
        itemList.mj_footer = customFooter
        
        let segue: AnyObserver<CouponItem> = NavigationSegue(
            fromViewController: self.navigationControllerHolder!,
            toViewControllerFactory:
            { (sender, context) -> DetailController in
                let detailController = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
                detailController.couponItem = context
                return detailController
        }).asObserver()
        
        itemList.rx.itemSelected
            .map{ indexPath -> CouponItem in
                return try self.itemList.rx.model(at: indexPath)
            }
            .bind(to: segue)
            .disposed(by: disposeBag)
    }
    
    public func search(_ navigationController: UINavigationController, _ input: String, _ isJu: Bool) {
        self.keyword = input
        self.isJu = isJu
        
        if setClickHandler {
            return;
        }
        self.navigationControllerHolder = navigationController
        setClickHandler = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
