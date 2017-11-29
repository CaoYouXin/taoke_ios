import RxSwift
import RxBus
import UserNotifications
import MJRefresh
import ELWaterFallLayout

class MessageController: UIViewController {
    
    @IBOutlet weak var messageList: UICollectionView!
    
    private let disposeBag = DisposeBag()
    
    private var messageListHelper: MVCHelper<MessageView>?
    private var cache: [Int:CGFloat] = [:]
    
    private var messages: [String?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBadge()
        initList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func initList() {
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
        
        messageList.register(UINib(nibName: "MessageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let messageListLayout = ELWaterFlowLayout()
        messageList.collectionViewLayout = messageListLayout
        
        messageListLayout.delegate = self
        messageListLayout.lineCount = 1
        messageListLayout.vItemSpace = 10
        messageListLayout.hItemSpace = 10
        messageListLayout.edge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let messageFactory: (UICollectionView, Int, MessageView) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MessageCell
            
            cell.title.text = element.title
            cell.time.text = element.dateStr
            cell.content.text = element.content
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor("#ffd500").cgColor
            cell.layer.cornerRadius = 5

            return cell
        }
        
        messageListHelper = MVCHelper<MessageView>(messageList)
        messageListHelper?.set(cellFactory: messageFactory)
        messageListHelper?.set(dataSource: MessageDataSource(self))
        messageListHelper?.set(dataHook: {messageViews in
            self.messages = []
            for messageView in messageViews {
                self.messages?.append(messageView.content)
            }
            return messageViews
        })
        
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
        var cellHeight = CGFloat(60)
        if let message = self.messages?[index] {
            let maxCountPerLine = 40
            let minHeightPerLine = CGFloat(20)
            let padding = CGFloat(15)
            let lines = (message.utf16.count / maxCountPerLine) + (message.utf16.count % maxCountPerLine > 0 ? 1 : 0)
            cellHeight += (minHeightPerLine * CGFloat(lines) + padding)
        }
        return cellHeight
    }
}
