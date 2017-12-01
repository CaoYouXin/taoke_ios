
import UIKit
import FontAwesomeKit
import MJRefresh

class OrdersController: UIViewController {

    @IBOutlet weak var allBtn: UIView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allIndicator: UIView!
    
    @IBOutlet weak var effectiveBtn: UIView!
    @IBOutlet weak var effectiveLabel: UILabel!
    @IBOutlet weak var effectiveIndicator: UIView!
    
    @IBOutlet weak var ineffectiveBtn: UIView!
    @IBOutlet weak var ineffectiveLabel: UILabel!
    @IBOutlet weak var ineffectiveIndecator: UIView!
    
    @IBOutlet weak var payedBtn: UIView!
    @IBOutlet weak var payedLabel: UILabel!
    
    @IBOutlet weak var deliveredBtn: UIView!
    @IBOutlet weak var deliveredLabel: UILabel!
    
    @IBOutlet weak var settledBtn: UIView!
    @IBOutlet weak var settledLabel: UILabel!
    
    @IBOutlet weak var secondSelection: UIStackView!
    @IBOutlet weak var secondSelectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var orderList: UICollectionView!
    @IBOutlet weak var orderListLayout: UICollectionViewFlowLayout!
    
    private var orderListHelper: MVCHelper<OrderView>?
    private var orderListDataSource: OrderDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "订单详情"
        
        initOrderList()
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        allBtn.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        effectiveBtn.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        ineffectiveBtn.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        payedBtn.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        deliveredBtn.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        settledBtn.addGestureRecognizer(tapGestureRecognizer)
        
        clicked(effectiveBtn)
    }
    
    private func initOrderList() {
        orderList.register(UINib(nibName: "OrderCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        orderListLayout.itemSize = CGSize(width: self.view.frame.size.width, height: 208)
        
        let orderFac: (UICollectionView, Int, OrderView) -> UICollectionViewCell = { (collectionView, row, element) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: IndexPath(row: row, section: 0)) as! OrderCell
            
            cell.thumb.kf.setImage(with: URL(string: element.picUrl!))
            cell.createTime.text = "\(element.dateStr!) 创建"
            cell.title.text = element.itemName
            cell.shop.text = "所属店铺: \(element.itemStoreName!)"
            
            cell.teammate.text = element.isSelf! ? "个人" : element.teammateName
            cell.teammateWidth.constant = cell.teammate.sizeThatFits(CGSize(width: 0, height: cell.teammate.frame.height)).width + 20
            
            cell.status.text = element.status
            switch element.status! {
            case "订单付款", "订单收货":
                cell.status.layer.backgroundColor = UIColor.blue.withAlphaComponent(0.5).cgColor
                break
            case "订单结算":
                cell.status.layer.backgroundColor = UIColor.green.withAlphaComponent(0.5).cgColor
                break
            case "订单失效":
                cell.status.layer.backgroundColor = UIColor.lightGray.cgColor
                break
            default:
                break
            }
            
            var text = "付款金额\n¥ \(element.itemTradePrice!)"
            var attribuites = NSMutableAttributedString(string: text)
            var location = (text.index(of: "¥")?.encodedOffset)! + 2
            var length = (text.index(of: ".")?.encodedOffset)! - location
            var range = NSRange(location: location, length: length)
            attribuites.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 28), range: range)
            cell.payedAmount.attributedText = attribuites
            
            text = "效果预估\n¥ \(element.estimateEffect!)"
            attribuites = NSMutableAttributedString(string: text)
            location = (text.index(of: "¥")?.encodedOffset)! + 2
            length = (text.index(of: ".")?.encodedOffset)! - location
            range = NSRange(location: location, length: length)
            attribuites.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 28), range: range)
            cell.estimateEffect.attributedText = attribuites
            
            text = "预估收入\n¥ \(element.estimateIncome!)"
            attribuites = NSMutableAttributedString(string: text)
            location = (text.index(of: "¥")?.encodedOffset)! + 2
            length = (text.index(of: ".")?.encodedOffset)! - location
            range = NSRange(location: location, length: length)
            attribuites.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 28), range: range)
            cell.estimateIncome.attributedText = attribuites
            
            return cell
        }
        
        orderListHelper = MVCHelper<OrderView>(orderList)
        orderListHelper?.set(cellFactory: orderFac)
        orderListDataSource = OrderDataSource(self)
        orderListHelper?.set(dataSource: orderListDataSource!)
        
        orderList.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.orderListHelper?.refresh()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.orderList.mj_header.endRefreshing()
            }
        })
        
        orderList.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.orderListHelper?.loadMore()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.orderList.mj_footer.endRefreshing()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        clicked(sender.view!)
    }
    
    private func clicked(_ view: UIView) {
        allLabel.textColor = UIColor.black
        effectiveLabel.textColor = UIColor.black
        ineffectiveLabel.textColor = UIColor.black
        
        allIndicator.layer.backgroundColor = UIColor.clear.cgColor
        effectiveIndicator.layer.backgroundColor = UIColor.clear.cgColor
        ineffectiveIndecator.layer.backgroundColor = UIColor.clear.cgColor
        
        payedLabel.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        payedLabel.layer.cornerRadius = 15
        payedLabel.textColor = UIColor.darkText
        
        deliveredLabel.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        deliveredLabel.layer.cornerRadius = 15
        deliveredLabel.textColor = UIColor.darkText
        
        settledLabel.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        settledLabel.layer.cornerRadius = 15
        settledLabel.textColor = UIColor.darkText
        
        switch view {
        case allBtn:
            allLabel.textColor = UIColor.orange
            allIndicator.layer.backgroundColor = UIColor.orange.cgColor
            secondSelection.isHidden = true
            secondSelectionHeight.constant = 0
            orderListDataSource?.type = OrderFetchType.ALL
            break;
        case effectiveBtn:
            effectiveLabel.textColor = UIColor.orange
            effectiveIndicator.layer.backgroundColor = UIColor.orange.cgColor
            secondSelection.isHidden = false
            secondSelectionHeight.constant = 50
            orderListDataSource?.type = OrderFetchType.ALL_EFFECTIVE
            break;
        case ineffectiveBtn:
            ineffectiveLabel.textColor = UIColor.orange
            ineffectiveIndecator.layer.backgroundColor = UIColor.orange.cgColor
            secondSelection.isHidden = true
            secondSelectionHeight.constant = 0
            orderListDataSource?.type = OrderFetchType.INEFFECTIVE
            break;
        case payedBtn:
            effectiveLabel.textColor = UIColor.orange
            effectiveIndicator.layer.backgroundColor = UIColor.orange.cgColor
            payedLabel.layer.backgroundColor = UIColor.orange.cgColor
            payedLabel.layer.cornerRadius = 15
            payedLabel.textColor = UIColor.white
            orderListDataSource?.type = OrderFetchType.EFFECTIVE_PAYED
            break;
        case deliveredBtn:
            effectiveLabel.textColor = UIColor.orange
            effectiveIndicator.layer.backgroundColor = UIColor.orange.cgColor
            deliveredLabel.layer.backgroundColor = UIColor.orange.cgColor
            deliveredLabel.layer.cornerRadius = 15
            deliveredLabel.textColor = UIColor.white
            orderListDataSource?.type = OrderFetchType.EFFECTIVE_CONSIGNED
            break;
        case settledBtn:
            effectiveLabel.textColor = UIColor.orange
            effectiveIndicator.layer.backgroundColor = UIColor.orange.cgColor
            settledLabel.layer.backgroundColor = UIColor.orange.cgColor
            settledLabel.layer.cornerRadius = 15
            settledLabel.textColor = UIColor.white
            orderListDataSource?.type = OrderFetchType.EFFECTIVE_SETTLED
            break;
        default:
            break;
        }
        orderListHelper?.refresh()
    }
    
}
