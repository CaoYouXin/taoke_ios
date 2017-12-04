import UIKit
import FontAwesomeKit
import MJRefresh
import RxSwift
import ELWaterFallLayout
import RxBus
import RxSegue

class HelpController: UIViewController {

    @IBOutlet weak var helpList: UICollectionView!
    
    private var cache: [Int: CGFloat] = [:]
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "帮助与反馈"
        
        initHelpList()
    }
    
    private func initHelpList() {
        let helpListLayout = ELWaterFlowLayout()
        helpList.collectionViewLayout = helpListLayout
        helpListLayout.prepare()
        
        helpListLayout.delegate = self
        helpListLayout.lineCount = 1
        helpListLayout.vItemSpace = 20
        helpListLayout.hItemSpace = 10
        helpListLayout.edge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        RxBus.shared.asObservable(event: Events.WaterFallLayout.self)
            .throttle(RxTimeInterval(1), latest: true, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .rxSchedulerHelper()
            .subscribe { event in
                helpListLayout.lineCount = 1
            }.disposed(by: disposeBag)
        
        let helpFactory: (UICollectionView, Int, HelpView) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HelpCell", for: indexPath) as! HelpCell
            
            let rightArrowIcon = FAKFontAwesome.chevronRightIcon(withSize: 16)
            rightArrowIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
            cell.arrow.image = rightArrowIcon?.image(with: CGSize(width: 16, height: 16))
            
            cell.title.text = element.title
            
            self.cache[row] = cell.title.sizeThatFits(CGSize(width: cell.frame.width * 0.632 - 20, height: 0)).height
            
            RxBus.shared.post(event: Events.WaterFallLayout())
            return cell
        }
        
        let helpListHelper = MVCHelper<HelpView>(helpList)
        helpListHelper.set(cellFactory: helpFactory)
        helpListHelper.set(dataSource: HelpDataSource(self))
        
        helpListHelper.refresh()
        
        helpList.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.cache.removeAll()
            helpListHelper.refresh()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.helpList.mj_header.endRefreshing()
            }
        })
        
        let segue: AnyObserver<HelpView> = NavigationSegue(
            fromViewController: self.navigationController!,
            toViewControllerFactory:
            { (sender, context) -> HelpDetailController in
                let detailController = UIStoryboard(name: "HelpReport", bundle: nil).instantiateViewController(withIdentifier: "HelpDetailController") as! HelpDetailController
                detailController.helpView = context
                return detailController
        }).asObserver()
        
        helpList.rx.itemSelected
            .map{ indexPath -> HelpView in
                return try self.helpList.rx.model(at: indexPath)
            }
            .bind(to: segue)
            .disposed(by: disposeBag)
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HelpController: ELWaterFlowLayoutDelegate  {
    func el_flowLayout(_ flowLayout: ELWaterFlowLayout, heightForRowAt index: Int) -> CGFloat {
        return self.cache[index] ?? 0
    }
}
