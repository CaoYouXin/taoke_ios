
import CleanroomLogger
import FontAwesomeKit
import ImageSlideshow
import RxSwift
import RxSegue
import AlibcTradeBiz

class DetailController: UIViewController {
    
    var couponItem: CouponItem?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var picSliders: ImageSlideshow!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailViewIcon: UIImageView!
    @IBOutlet weak var couponPriceWrapper: UIView!
    @IBOutlet weak var detailPriceAfterIcon: UILabel!
    @IBOutlet weak var detailPriceAfterIconWidth: NSLayoutConstraint!
    @IBOutlet weak var detailPriceAfter: UILabel!
    @IBOutlet weak var noCouponWrapper: UIView!
    @IBOutlet weak var detailPriceBefore: UILabel!
    @IBOutlet weak var detailSales: UILabel!
    @IBOutlet weak var couponWrapper: UIView!
    @IBOutlet weak var couponPriceBefore: UILabel!
    @IBOutlet weak var saleVolume: UILabel!
    @IBOutlet weak var couponInfoWrapper: UIView!
    @IBOutlet weak var detailCouponIcon: UIImageView!
    @IBOutlet weak var detailCoupon: UILabel!
    @IBOutlet weak var earnWrapper: UIView!
    @IBOutlet weak var detailCommissionIcon: UIImageView!
    @IBOutlet weak var detailCommission: UILabel!
    @IBOutlet weak var buyerWrapper: UIView!
    @IBOutlet weak var detailShare: UILabel!
    @IBOutlet weak var detailApp: UILabel!
    @IBOutlet weak var agentShare: UILabel!
    @IBOutlet weak var itemPage: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "宝贝推广信息"
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        detailShare.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        detailApp.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        agentShare.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        itemPage.addGestureRecognizer(tapGestureRecognizer)
        
        initView()
    }
    
    private func initView() {
        self.picSliders.slideshowInterval = 3
        self.picSliders.contentScaleMode = .scaleAspectFill
        var imageSources: [KingfisherSource] = [KingfisherSource(urlString: (couponItem?.pictUrl)!)!];
        if let smallImages = couponItem?.smallImages {
            for url in smallImages {
                imageSources.append(KingfisherSource(urlString: url)!)
            }
        }
        self.picSliders.setImageInputs(imageSources)
        
        self.detailTitle.text = couponItem?.title
        
        let newspaperOIcon = FAKFontAwesome.newspaperOIcon(withSize: 20)
        newspaperOIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#424242"))
        self.detailViewIcon.image = newspaperOIcon?.image(with: CGSize(width: 20, height: 20))
        
        if couponItem?.couponInfo == nil {
            couponInfoWrapper.isHidden = true
            
            if couponItem?.commissionRate == nil {
                couponWrapper.isHidden = false
                noCouponWrapper.isHidden = true
                couponPriceWrapper.isHidden = false
                saleVolume.isHidden = true
                
                self.detailPriceAfterIcon.layer.cornerRadius = 2;
                self.detailPriceAfterIcon.layer.masksToBounds = true;
                self.detailPriceAfterIcon.layer.borderWidth = 1
                self.detailPriceAfterIcon.layer.borderColor = UIColor("#f57c00").cgColor
                self.detailPriceAfterIcon.text = "聚划算价"
                self.detailPriceAfterIconWidth.constant = self.detailPriceAfterIcon.sizeThatFits(CGSize(width: 0, height: 0)).width + 10
                
                var text = "现价 ¥ \(couponItem?.zkFinalPrice! ?? "")"
                var location = text.index(of: "¥")!.encodedOffset + 2
                var range = NSRange(location: location, length: text.utf16.count - location)
                var attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSUnderlineStyle.patternSolid.rawValue | NSUnderlineStyle.styleSingle.rawValue, range: range)
                self.detailPriceBefore.attributedText = attributedText
                
                text = "¥ \(couponItem?.couponPrice ?? "0.0")"
                location = text.index(of: ".")!.encodedOffset
                range = NSRange(location: 0, length: location)
                attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: range)
                self.detailPriceAfter.attributedText = attributedText
            } else {
                couponWrapper.isHidden = true
                noCouponWrapper.isHidden = false
                couponPriceWrapper.isHidden = true
                saleVolume.isHidden = false
                couponPriceBefore.text = "现价 ¥ \(couponItem?.zkFinalPrice! ?? "")"
                saleVolume.text = "已售\(couponItem?.volume! ?? 0)件"
            }
        } else {
            
            couponWrapper.isHidden = false
            couponInfoWrapper.isHidden = false
            noCouponWrapper.isHidden = true
            couponPriceWrapper.isHidden = false
            
            self.detailPriceAfterIcon.layer.cornerRadius = 2;
            self.detailPriceAfterIcon.layer.masksToBounds = true;
            self.detailPriceAfterIcon.layer.borderWidth = 1
            self.detailPriceAfterIcon.layer.borderColor = UIColor("#f57c00").cgColor
            self.detailPriceAfterIcon.text = "券后价"
            self.detailPriceAfterIconWidth.constant = self.detailPriceAfterIcon.sizeThatFits(CGSize(width: 0, height: 0)).width + 10
            
            var text = "现价 ¥ \(couponItem?.zkFinalPrice! ?? "")"
            var location = text.index(of: "¥")!.encodedOffset + 2
            var range = NSRange(location: location, length: text.utf16.count - location)
            var attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSUnderlineStyle.patternSolid.rawValue | NSUnderlineStyle.styleSingle.rawValue, range: range)
            self.detailPriceBefore.attributedText = attributedText
            
            text = "¥ \(couponItem?.couponPrice ?? "0.0")"
            location = text.index(of: ".")!.encodedOffset
            range = NSRange(location: 0, length: location)
            attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: range)
            self.detailPriceAfter.attributedText = attributedText
            
            text = "优惠券 \(couponItem?.couponInfo! ?? "")"
            location = text.index(of: "减")!.encodedOffset
            range = NSRange(location: location, length: text.count - location)
            attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: range)
            self.detailCoupon.attributedText = attributedText
            
            self.detailSales.text = "已售\(couponItem?.volume! ?? 0)件"
            
            let ticketStarIcon = FAKMaterialIcons.ticketStarIcon(withSize: 16)
            ticketStarIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
            self.detailCouponIcon.image = ticketStarIcon?.image(with: CGSize(width: 16, height: 16))
        }
        
        if !(UserData.get()?.isBuyer())!, let earn = couponItem?.earnPrice {
            earnWrapper.isHidden = false
            buyerWrapper.isHidden = true
            agentShare.isHidden = false
            
            let moneyIcon = FAKFontAwesome.moneyIcon(withSize: 16)
            moneyIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
            self.detailCommissionIcon.image = moneyIcon?.image(with: CGSize(width: 16, height: 16))
            
            let text = "分享预计赚 ¥ \(earn)"
            let location = text.index(of: "¥")!.encodedOffset + 2
            let length = (text.index(of: ".")?.encodedOffset)! - location
            let range = NSRange(location: location, length: length)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: range)
            self.detailCommission.attributedText = attributedText
        } else {
            earnWrapper.isHidden = true
            buyerWrapper.isHidden = false
            agentShare.isHidden = true
            
            var start = couponItem?.couponInfo?.index(of: "减")
            start = couponItem?.couponInfo?.index(after: start!)
            let coupon = couponItem?.couponInfo?[start!...]
            detailApp.text = "领 \(coupon!) 券"
        }
        
        if let constraint = (self.couponInfoWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.couponItem?.couponInfo == nil ? 0 : 20
        }
        
        if let constraint = (self.couponWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.couponItem?.couponInfo == nil && couponItem?.commissionRate != nil ? 0 : 30
        }
        
        if let constraint = (self.noCouponWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.couponItem?.couponInfo == nil && couponItem?.commissionRate != nil ? 30 : 0
        }
        
        if let constraint = (self.couponPriceWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.couponItem?.couponInfo == nil && couponItem?.commissionRate != nil ? 0 : 30
        }
        
        if let constraint = (self.earnWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = (UserData.get()?.isBuyer())! || couponItem?.earnPrice == nil ? 0 : 20
        }
        
        if let constraint = (self.agentShare.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = (UserData.get()?.isBuyer())! ? 0 : 48
        }
        
        if let constraint = (self.buyerWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = (UserData.get()?.isBuyer())! ? 48 : 0
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case detailShare, agentShare:
            let shareController = UIStoryboard(name: "Share", bundle: nil).instantiateViewController(withIdentifier: "ShareController") as! ShareController
            shareController.couponItem = couponItem
            self.navigationController?.pushViewController(shareController, animated: true)
            break
        case detailApp:
            if let taokeUrl = couponItem?.couponClickUrl ?? couponItem?.tkLink {
                let page = AlibcTradePageFactory.page(taokeUrl)
                let showParam = AlibcTradeShowParams()
                showParam.openType = .native
                let taokeParams = AlibcTradeTaokeParams()
                taokeParams.pid = UserData.get()?.pid
                AlibcTradeSDK.sharedInstance().tradeService().show(self, page: page, showParams: showParam, taoKeParams: taokeParams, trackParam: nil, tradeProcessSuccessCallback: { (alibcTradeResult) in
                    print(">>> alibc open taobao successfully")
                }, tradeProcessFailedCallback: { (error) in
                    print(">>> alibc open taobao fail \(error.debugDescription)")
                })
            }
            break
        case itemPage:
            if let itemId = couponItem?.numIid {
                let h5DetailController = UIStoryboard(name: "H5Detail", bundle: nil).instantiateViewController(withIdentifier: "H5DetailController") as! H5DetailController
                h5DetailController.itemId = String(itemId)
                self.navigationController?.pushViewController(h5DetailController, animated: true)
            }
            break
        default:
            break
        }
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

