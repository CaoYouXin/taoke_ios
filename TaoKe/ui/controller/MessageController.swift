import RxSwift
import RxBus
import UserNotifications

class MessageController: UIViewController {
    
    @IBOutlet weak var scrollWrapper: UIScrollView!
    @IBOutlet weak var messageList: UICollectionView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBadge()
        initList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initList() {
        //        let shareTemplateLayout = ELWaterFlowLayout()
        //        shareTemplateList.collectionViewLayout = shareTemplateLayout
        //
        //        shareTemplateLayout.delegate = self
        //        shareTemplateLayout.lineCount = 1
        //        shareTemplateLayout.vItemSpace = 10
        //        shareTemplateLayout.hItemSpace = 10
        //        shareTemplateLayout.edge = UIEdgeInsets.zero
        //        shareTemplateLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        //
        //        //refresh layout
        //        RxBus.shared.asObservable(event: Events.WaterFallLayout.self)
        //            .throttle(RxTimeInterval(1), latest: true, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
        //            .rxSchedulerHelper()
        //            .subscribe { event in
        //                shareTemplateLayout.lineCount = 1
        //            }.disposed(by: disposeBag)
        //
        //        let shareTemplateFac: (UICollectionView, Int, ShareImage) -> UICollectionViewCell = { (collectionView, row, element) in
        //            let indexPath = IndexPath(row: row, section: 0)
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ShareTemplateCell
        //
        //            if (self.cache[row] ?? 0 == 0) {
        //                cell.template.layer.borderWidth = 1
        //                cell.template.layer.borderColor = UIColor("#bdbdbd").cgColor
        //                cell.template.addConstraint(NSLayoutConstraint(item: cell.template, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0))
        //                cell.template.kf.setImage(with: URL(string: element.thumb!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
        //                    if let tmp = image {
        //                        let ratio = tmp.size.width / tmp.size.height
        //                        let width = cell.template.frame.height * ratio
        //
        //                        if let constraint = (cell.template.constraints.filter{$0.firstAttribute == NSLayoutAttribute.width}.first) {
        //                            constraint.constant = width
        //                        }
        //
        //                        self.cache[row] = width
        //                        RxBus.shared.post(event: Events.WaterFallLayout())
        //                    }
        //                })
        //            }
        //
        //            let checkCircleIcon = FAKFontAwesome.checkCircleIcon(withSize: 24)
        //            checkCircleIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor(element.selected! ? "#e65100" : "#00000080"))
        //            cell.select.image = checkCircleIcon?.image(with: CGSize(width: 24, height: 24))
        //            return cell
        //        }
        //
        //        shareTemplateDS = ShareTemplateDataSource(viewController: self)
        //        shareTemplateDS?.selected = -1
        //
        //        let shareTemplateDH: ([ShareImage]) -> [ShareImage] = {
        //            shareImages in
        //            if shareImages.count > 0 && self.shareTemplateDS?.selected == -1 {
        //                shareImages[0].selected = true
        //            }
        //            return shareImages
        //        }
        //
        //        let shareTempalteHelper = MVCHelper<ShareImage>(shareTemplateList)
        //
        //        shareTempalteHelper.set(cellFactory: shareTemplateFac)
        //        shareTempalteHelper.set(dataSource: shareTemplateDS)
        //        shareTempalteHelper.set(dataHook: shareTemplateDH)
        //
        //        shareTempalteHelper.refresh()
    }
    
    private func initBadge() {
        RxBus.shared.asObservable(event: Events.Message.self).rxSchedulerHelper().subscribe({ event in
            if let message = event.element {
                self.tabBarItem.badgeValue = message.count == 0 ? nil : "\(message.count)"
                UIApplication.shared.applicationIconBadgeNumber = message.count
            }
        }).disposed(by: disposeBag)
        
        let _ = Observable<Int>.interval(RxTimeInterval(600), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { _ in
                let _ = TaoKeApi.countUnreadMessages().rxSchedulerHelper().handleUnAuth(viewController: self)
                    .subscribe(onNext: { (unreads) in
                        RxBus.shared.post(event: Events.Message(count: Int(unreads)))
                    })
            })
    }
    
}
