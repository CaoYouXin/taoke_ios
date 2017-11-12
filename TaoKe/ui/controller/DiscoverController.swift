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
import MEVFloatingButton
import FontAwesomeKit

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

        initHeaderView()
        initCouponList()
        initScrollView()
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
        couponList.register(UINib(nibName: "CouponCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        couponListFlowLayout.itemSize = CGSize(width: view.frame.size.width, height: 112)
        
        let couponDataSource = TaoKeApi.getCouponList()
            .catchError({ (error) -> Observable<[CouponItem]> in
                Log.error?.message(error.localizedDescription)
                return Observable.empty()
            })
        
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
            couponPriceAfterMutableAttributed.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
            couponPriceAfterMutableAttributed.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: range)
            cell.couponPriceAfter.attributedText = couponPriceAfterMutableAttributed
            
            cell.couponValue.text = "券 | \(element.value!)元        余\(element.left!)张"
            cell.couponEarn.text = "赚 ¥ \(element.earn!)"
            return cell
        }
        
        couponViewModel
            .forwardSignalWhileActive(couponDataSource)
            .rxSchedulerHelper()
            .bind(to: couponList.rx.items)(couponCellFactory)
            .disposed(by: disposeBag)
        
        couponViewModel.active = true
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
                self.scrollView.mj_footer.isHidden = true
                self.scrollView.mj_footer.isHidden = false
            }
        })

        scrollView.mj_footer.isAutomaticallyHidden = false
        
        let floatingButton = MEVFloatingButton()
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
