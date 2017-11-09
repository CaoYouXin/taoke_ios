//
//  DiscoverController.swift
//  TaoKe
//
//  Created by jason tsang on 11/6/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import CleanroomLogger
import RxSwift
import RxCocoa
import RxViewModel
import MJRefresh

class DiscoverController: UIViewController {
  
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var couponList: UICollectionView!
    @IBOutlet weak var couponListFlowLayout: UICollectionViewFlowLayout!
    
    var discoverHeaderView: DiscoverHeaderView?
    
    let disposeBag = DisposeBag()
    
    let couponViewModel = RxViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        initScrollView()
        initHeaderView()
        initCouponList()
    }
    
    private func initScrollView() {
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.scrollView.mj_header.endRefreshing()
            }
        })
        
        scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.scrollView.mj_footer.endRefreshing()
            }
        })
    }
    
    private func initHeaderView() {
        let nibViews = Bundle.main.loadNibNamed("DiscoverHeaderView", owner: self, options: nil)
        discoverHeaderView = nibViews?.first as? DiscoverHeaderView
        
        if let headerView = discoverHeaderView {
            headerView.frame = CGRect(x: headerView.frame.origin.x, y: headerView.frame.origin.y, width: view.frame.size.width, height: headerView.frame.size.height)
            
            couponList.addSubview(headerView)
        }
    }
    
    private func initCouponList() {
        if #available(iOS 11.0, *) {
            couponList.contentInsetAdjustmentBehavior = .never
        }
        
        if let constraint = (couponList.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.view.frame.size.height
        }
        
        couponList.register(UINib(nibName: "CouponCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        couponListFlowLayout.itemSize = CGSize(width: view.frame.size.width, height: 112)
        
        let couponDataSource = TaoKeApi.getBrandList()
            .catchError({ (error) -> Observable<[BrandItem]> in
                Log.error?.message(error.localizedDescription)
                return Observable.empty()
            })
        
        let couponCellFactory: (UICollectionView, Int, BrandItem) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CouponCell

            //cell.thumb.image = #imageLiteral(resourceName: "splash")
            cell.thumb.kf.setImage(with: URL(string: element.thumb!))
            return cell
        }
        
        couponViewModel
            .forwardSignalWhileActive(couponDataSource)
            .rxSchedulerHelper()
            .bind(to: couponList.rx.items)(couponCellFactory)
            .disposed(by: disposeBag)
        
        couponViewModel.active = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
