import CleanroomLogger
import RxSwift
import RxBus
import RxSegue
import MJRefresh
import MEVFloatingButton
import TabLayoutView
import FontAwesomeKit

class DiscoverController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var couponList: UICollectionView!
    @IBOutlet weak var couponListFlowLayout: UICollectionViewFlowLayout!
    
    private let floatingButton: MEVFloatingButton = MEVFloatingButton()
    private var discoverHeaderView: DiscoverHeaderView?
    private var couponDataSource: CouponDataSource?
    private var couponListHelper: MVCHelper<CouponItem>?
    
    var disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        couponDataSource = CouponDataSource(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMJRefresh()
        initFloatingButton()
        initCouponList()
        initHeaderView()
    }
    
    private func initHeaderView() {
        RxBus.shared.asObservable(event: Events.ViewDidLoad.self)
            .rxSchedulerHelper()
            .subscribe { event in
                self.couponList.setContentOffset(CGPoint(x: 0, y: 1 - self.discoverHeaderView!.maximumContentHeight), animated: false)
            }.disposed(by: disposeBag)
        
        let nibViews = Bundle.main.loadNibNamed("DiscoverHeaderView", owner: self, options: nil)
        discoverHeaderView = nibViews?.first as? DiscoverHeaderView
        
        if let headerView = discoverHeaderView {
            headerView.setController(ctrl: self)
            
            var adjust = CGFloat(0)
            let height = self.view.frame.size.height
            if height == 568 {
                adjust -= 16
            }else if height == 736 {
                adjust += 16
            }
            headerView.maxContentHeight += adjust
            
            couponList.addSubview(headerView)
            
            let segue: AnyObserver<HomeBtn> = NavigationSegue(
                fromViewController: self.navigationController!,
                toViewControllerFactory:
                { (sender, context) -> ProductListController in
                    let productListController = UIStoryboard(name: "ProductList", bundle: nil).instantiateViewController(withIdentifier: "ProductListController") as! ProductListController
                    productListController.homeBtn = context
                    return productListController
            }).asObserver()
            
            headerView.brandList.rx.itemSelected
                .map{ indexPath -> HomeBtn in
                    return try headerView.brandList.rx.model(at: indexPath)
                }
                .bind(to: segue)
                .disposed(by: disposeBag)
            
            headerView.couponTab.delegate = self
        }
    }
    
    private func initCouponList() {
        if #available(iOS 11.0, *) {
            self.couponList.contentInsetAdjustmentBehavior = .never
        }
        
        couponList.register(UINib(nibName: "CouponCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        couponListFlowLayout.itemSize = CGSize(width: view.frame.size.width, height: 112)
        
        let couponCellFactory: (UICollectionView, Int, CouponItem) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CouponCell
            
            if let constraint = (cell.couponEarn.constraints.filter({$0.firstAttribute == .height}).first) {
                constraint.constant = (UserData.get()?.isBuyer())! ? 0 : 15
            }
            
            cell.thumb.kf.setImage(with: URL(string: element.pictUrl!))
            cell.couponTitle.text = element.title!
            cell.couponPriceBefore.text = "现价 ¥ \(element.zkFinalPrice!)"
            cell.volume.text = "月销 \(element.volume!) 件"
            
            let couponPriceAfter = "券后价 ¥ \(element.couponPrice!)"
            let couponPriceAfterMutableAttributed = NSMutableAttributedString(string: couponPriceAfter)
            let location = couponPriceAfter.index(of: "¥")?.encodedOffset
            let range = NSRange(location: location!, length: couponPriceAfter.utf16.count - location!)
            couponPriceAfterMutableAttributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
            couponPriceAfterMutableAttributed.addAttribute(.foregroundColor, value: UIColor.black, range: range)
            cell.couponPriceAfter.attributedText = couponPriceAfterMutableAttributed
            
            let progress = Float(element.couponRemainCount!) / Float(element.couponTotalCount!)
            if cell.couponProgress.progress != progress {
                cell.couponProgress.progress = 0
                cell.couponProgress.layoutIfNeeded()
            }
            cell.couponProgress.progress = progress
            UIView.animate(withDuration: 1, animations: { () -> Void in
                cell.couponProgress.layoutIfNeeded()
            })
            
            cell.couponValue.text = "券 | \(element.couponInfo!)"
            cell.couponEarn.text = "赚 ¥ \(element.earnPrice!)"
            return cell
        }
        
        couponListHelper = MVCHelper(couponList)
        couponListHelper?.set(cellFactory: couponCellFactory)
        couponListHelper?.set(dataSource: couponDataSource)
        
        let segue: AnyObserver<CouponItem> = NavigationSegue(
            fromViewController: self.navigationController!,
            toViewControllerFactory:
            { (sender, context) -> DetailController in
                let detailController = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
                detailController.couponItem = context
                return detailController
        }).asObserver()
        
        couponList.rx.itemSelected
            .map{ indexPath -> CouponItem in
                return try self.couponList.rx.model(at: indexPath)
            }
            .bind(to: segue)
            .disposed(by: disposeBag)
        
        couponList.rx.didScroll.subscribe(onNext: {
            let isExpanded = self.discoverHeaderView?.frame.size.height != self.discoverHeaderView?.minimumContentHeight
            if isExpanded {
                self.floatingButton.isHidden = true
            }else {
                self.floatingButton.isHidden = false
            }
        }, onError: { (error) in
            Log.error?.message(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    private func initMJRefresh() {
        let customHeader = MJRefreshNormalHeader(refreshingBlock: {
            self.discoverHeaderView?.refreshHeader()
            print(">>>refresh discover page")
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.scrollView.mj_header.endRefreshing()
            }
        })

        scrollView.mj_header = customHeader
        
        let customFooter = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.couponList.mj_footer.endRefreshingWithNoMoreData()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.couponList.mj_footer.resetNoMoreData()
            }
        })
        customFooter?.setTitle("我们是有底线的！😊", for: .noMoreData)
        customFooter?.setTitle("我们是有底线的！😊", for: .idle)
        customFooter?.setTitle("我们是有底线的！😊", for: .pulling)
        customFooter?.setTitle("我们是有底线的！😊", for: .refreshing)
        customFooter?.setTitle("我们是有底线的！😊", for: .willRefresh)
        
        couponList.mj_footer = customFooter
    }
    
    private func initFloatingButton() {
        floatingButton.isHidden = true
        floatingButton.image = FAKMaterialIcons.formatValignTopIcon(withSize: 20).image(with: CGSize(width: 20, height: 20))
        floatingButton.imageColor = UIColor("#424242")
        floatingButton.backgroundColor = UIColor.white
        floatingButton.position = .bottomRight
        floatingButton.isRounded = true
        floatingButton.horizontalOffset = -20;
        floatingButton.layer.shadowColor = UIColor.black.cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        floatingButton.layer.shadowOpacity = 0.2;
        scrollView.setFloatingButton(floatingButton)
        
        scrollView.floatingButtonDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func refreshCouponList(cid: String) {
        couponDataSource?.set(cid: cid)
        couponListHelper?.refresh()
    }
}

extension DiscoverController: MEVFloatingButtonDelegate {
    func floatingButton(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        couponList.setContentOffset(CGPoint(x: 0, y: -discoverHeaderView!.maximumContentHeight), animated: true)
    }
}

extension DiscoverController: TabLayoutViewDelegate {
    func tabLayoutView(_ tabLayoutView: TabLayoutView, didSelectTabAt index: Int) {
        couponList.setContentOffset(CGPoint(x: 0, y: -discoverHeaderView!.minimumContentHeight), animated: true)
        couponDataSource?.set(cid: (CouponTab.cache?[index].cid)!)
        couponListHelper?.refresh()
    }
}
