//
//  DiscoverController.swift
//  TaoKe
//
//  Created by jason tsang on 11/6/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
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
    
    private let floatingButton: MEVFloatingButton = MEVFloatingButton()
    
    @IBOutlet weak var couponList: UICollectionView!
    @IBOutlet weak var couponListFlowLayout: UICollectionViewFlowLayout!
    
    private var discoverHeaderView: DiscoverHeaderView?
    
    private let disposeBag = DisposeBag()
    
    private let couponDataSource = CouponDataSource()
    private var couponListHelper: MVCHelper<CouponItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initScrollView()
        initFloatingButton()
        initHeaderView()
        initCouponList()
    }
    
    private func initHeaderView() {
        //fix the headerview bug, any better way?
        RxBus.shared.asObservable(event: Events.ViewDidLoad.self)
            .rxSchedulerHelper()
            .subscribe { event in
                if self.couponList.numberOfItems(inSection: 0) > 0 {
                    self.couponList.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
            }.disposed(by: disposeBag)
        
        let nibViews = Bundle.main.loadNibNamed("DiscoverHeaderView", owner: self, options: nil)
        discoverHeaderView = nibViews?.first as? DiscoverHeaderView
        
        if let headerView = discoverHeaderView {
            //fix the headerview bug, any better way?
            var adjust = CGFloat(0)
            let height = self.view.frame.size.height
            if height == 568 {
                adjust -= 16
            }else if height == 736 {
                adjust += 16
            }
            headerView.maximumContentHeight += adjust
            
            couponList.addSubview(headerView)
            
            let segue: AnyObserver<BrandItem> = NavigationSegue(
                fromViewController: self.navigationController!,
                toViewControllerFactory:
                { (sender, context) -> ProductListController in
                    let productListController = UIStoryboard(name: "ProductList", bundle: nil).instantiateViewController(withIdentifier: "ProductListController") as! ProductListController
                    productListController.brandItem = context
                    return productListController
            }).asObserver()
            
            headerView.brandList.rx.itemSelected
                .map{ indexPath -> BrandItem in
                    return try headerView.brandList.rx.model(at: indexPath)
                }
                .bind(to: segue)
                .disposed(by: disposeBag)
            
            headerView.couponTab.delegate = self
        }
    }
    
    private func initCouponList() {
        couponList.register(UINib(nibName: "CouponCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        couponListFlowLayout.itemSize = CGSize(width: view.frame.size.width, height: 112)
        
        let couponCellFactory: (UICollectionView, Int, CouponItem) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CouponCell
            
            //cell.thumb.image = #imageLiteral(resourceName: "splash")
            cell.thumb.kf.setImage(with: URL(string: element.thumb!))
            cell.couponTitle.text = element.title!
            cell.couponPriceBefore.text = "现价 ¥ \(element.priceBefore!)        月销量 \(element.sales!) 件"
            
            let couponPriceAfter = "券后价 ¥ \(element.priceAfter!)"
            let couponPriceAfterMutableAttributed = NSMutableAttributedString(string: couponPriceAfter)
            let location = couponPriceAfter.index(of: "¥")?.encodedOffset
            let range = NSRange(location: location!, length: couponPriceAfter.utf16.count - location!)
            couponPriceAfterMutableAttributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
            couponPriceAfterMutableAttributed.addAttribute(.foregroundColor, value: UIColor.black, range: range)
            cell.couponPriceAfter.attributedText = couponPriceAfterMutableAttributed
            
            let progress = Float(element.left!) / Float(element.total!)
            if cell.couponProgress.progress != progress {
                cell.couponProgress.progress = 0
                cell.couponProgress.layoutIfNeeded()
            }
            cell.couponProgress.progress = progress
            UIView.animate(withDuration: 1, animations: { () -> Void in
                cell.couponProgress.layoutIfNeeded()
            })
            
            cell.couponValue.text = "券 | \(element.value!)元        余\(element.left!)张"
            cell.couponEarn.text = "赚 ¥ \(element.earn!)"
            return cell
        }
        
        couponListHelper = MVCHelper(couponList)
        couponListHelper?.set(cellFactory: couponCellFactory)
        couponListHelper?.set(dataSource: couponDataSource)
        couponListHelper?.refresh()
        
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
    
    private func initScrollView() {
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.couponListHelper?.refresh()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.scrollView.mj_header.endRefreshing()
            }
        })
        
        scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.couponListHelper?.loadMore()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.scrollView.mj_footer.isHidden = true
                self.scrollView.mj_footer.isHidden = false
            }
        })
        
        scrollView.mj_footer.isAutomaticallyHidden = false
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
        // Dispose of any resources that can be recreated.
    }
}

extension DiscoverController: MEVFloatingButtonDelegate {
    func floatingButton(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        couponList.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

extension DiscoverController: TabLayoutViewDelegate {
    func tabLayoutView(_ tabLayoutView: TabLayoutView, didSelectTabAt index: Int) {
        couponList.setContentOffset(CGPoint(x: 0, y: discoverHeaderView!.maximumContentHeight), animated: true)
        couponDataSource.set(index)
        couponListHelper?.refresh()
    }
}
