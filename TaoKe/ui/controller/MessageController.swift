import RxSwift
import RxBus
import UserNotifications
import MJRefresh
import ELWaterFallLayout

class MessageController: UIViewController {
    
    @IBOutlet weak var messageList: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private var messageListHelper: MVCHelper<MessageView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBadge()
        initList()
        initScroll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initScroll() {
        messageList.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.messageListHelper?.refresh()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.messageList.mj_header.endRefreshing()
            }
        })
        
        messageList.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.messageListHelper?.loadMore()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.messageList.mj_footer.endRefreshing()
            }
        })
    }
    
    private func initList() {
        let messageListLayout = ELWaterFlowLayout()
        messageList.collectionViewLayout = messageListLayout
        
        messageListLayout.delegate = self
        messageListLayout.lineCount = 1
        messageListLayout.vItemSpace = 10
        messageListLayout.hItemSpace = 10
        messageListLayout.edge = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        RxBus.shared.asObservable(event: Events.WaterFallLayout.self)
            .throttle(RxTimeInterval(1), latest: true, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .rxSchedulerHelper()
            .subscribe { event in
                messageListLayout.lineCount = 1
            }.disposed(by: disposeBag)
        
        let messageFactory: (UICollectionView, Int, MessageView) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCell
            
            cell.title.text = element.title
            cell.time.text = element.dateStr
            cell.content.text = element.content
            
            cell.title.textAlignment = .left;
            cell.title.numberOfLines = 0;
            cell.title.sizeToFit()
            cell.content.textAlignment = .left;
            cell.content.numberOfLines = 0;
            cell.content.sizeToFit()
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor("#FFD500").cgColor
            cell.layer.cornerRadius = 5
            
            RxBus.shared.post(event: Events.WaterFallLayout())
            return cell
        }
        
        messageListHelper = MVCHelper<MessageView>(messageList)
        messageListHelper?.set(cellFactory: messageFactory)
        messageListHelper?.set(dataSource: MessageDataSource(self))
        
        messageListHelper?.refresh()
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
        
        let _ = TaoKeApi.countUnreadMessages().rxSchedulerHelper().handleUnAuth(viewController: self)
            .subscribe(onNext: { (unreads) in
                RxBus.shared.post(event: Events.Message(count: Int(unreads)))
            })
    }
    
}

extension MessageController: ELWaterFlowLayoutDelegate  {
    func el_flowLayout(_ flowLayout: ELWaterFlowLayout, heightForRowAt index: Int) -> CGFloat {
        if let cell = self.messageList.cellForItem(at: IndexPath(row: index, section: 0)) as? MessageCell  {
            return cell.title.frame.size.height + cell.time.frame.size.height + cell.content.frame.size.height + CGFloat(40)
        }
        return 0
    }
}
