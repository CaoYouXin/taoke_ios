
import RxSwift

class TaoKeApi {
    
//    public static var CDN = "http://192.168.0.136:8070/"
    public static let CDN = "http://192.168.1.115:8070/"
//    public static var CDN = "http://server.tkmqr.com:8070/"
    
    public static func verification(phone: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_VERIFICATION, auth: "", data: ["phone": phone])
            .handleResult()
    }
    
    public static func signUp(phone: String, verificationCode: String, password: String, nick: String, invication: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_SIGN_UP, auth: "", data: ["code": verificationCode, "invitation": invication, "user": ["phone": phone, "name": nick, "pwd": password.md5()]])
            .handleResult()
            .map({ (taoKeData) -> TaoKeData? in
                UserData.setBy(from: taoKeData)?.cache()
                return taoKeData
            })
    }
    
    public static func anonymous() -> Observable<TaoKeData?> {
        var anonymous = UserDefaults.standard.string(forKey: "anonymous")
        if (nil == anonymous) {
            anonymous = "\(Date())".md5()
            UserDefaults.standard.setValue(anonymous, forKey: "anonymous")
        }
        print(">>>\(anonymous!)")
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_ANONYMOUS_LOGIN.replacingOccurrences(of: "{hash}", with: anonymous!))
            .handleResult()
            .map({ (taoKeData) -> TaoKeData? in
                UserData.setBy(from: taoKeData)?.cache()
                return taoKeData
            })
    }
    
    public static func signIn(phone: String, password: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_SIGN_IN, auth: "nil", data: ["phone": phone, "pwd": password.md5()])
            .handleResult()
            .map({ (taoKeData) -> TaoKeData? in
                UserData.setBy(from: taoKeData)?.cache()
                return taoKeData
            })
    }
    
    public static func resetPassword(phone: String, verificationCode: String, password: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_RESET_PASSWORD, auth: "", data: ["phone": phone, "smsCode": verificationCode, "pwd": password.md5()])
            .handleResult()
            .map({ (taoKeData) -> TaoKeData? in
                UserData.setBy(from: taoKeData)?.cache()
                return taoKeData
            })
    }
    
    public static func getBrandList() -> Observable<[HomeBtn]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_BRAND_LIST)
            .handleResult()
            .map({ (taoKeData) -> [HomeBtn] in
                var items: [HomeBtn] = []
                for rec in (taoKeData?.getList())! {
                    let item = HomeBtn();
                    item.name = rec["name"] as? String
                    item.ext = rec["ext"] as? String
                    item.imgUrl = CDN + (rec["imgUrl"] as? String)!
                    item.openType = rec["openType"] as! Int
                    items.append(item)
                }
                return items
            })
    }
    
    public static func getProductList(_ gourpId: String) -> Observable<[CouponItem]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_PRODUCT_LIST.replacingOccurrences(of: "{favId}", with: gourpId).replacingOccurrences(of: "{pageNo}", with: "1"), auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> [CouponItem] in
                var items: [CouponItem] = []
                for rec in (taoKeData?.getList())! {
                    let item = CouponItem()
                    item.category = rec["category"] as? Int64
                    item.userType = rec["userType"] as? Int64
                    item.numIid = rec["numIid"] as? Int64
                    item.sellerId = rec["sellerId"] as? Int64
                    item.volume = rec["volume"] as? Int64
                    item.smallImages = rec["smallImages"] as? [String]
                    item.commissionRate = rec["tkRate"] as? String
                    item.zkFinalPrice = rec["zkFinalPriceWap"] as? String
                    item.itemUrl = rec["itemUrl"] as? String
                    item.nick = rec["nick"] as? String
                    item.pictUrl = rec["pictUrl"] as? String
                    item.title = rec["title"] as? String
                    item.shopTitle = rec["shopTitle"] as? String
                    item.itemDescription = rec["itemDescription"] as? String
                    item.tkLink = rec["clickUrl"] as? String
                    
                    item.couponInfo = rec["couponInfo"] as? String
                    if item.couponInfo != nil {
                        
                        item.couponClickUrl = rec["couponClickUrl"] as? String
                        item.couponEndTime = rec["couponEndTime"] as? String
                        item.couponStartTime = rec["couponStartTime"] as? String
                        item.couponRemainCount = rec["couponRemainCount"] as? Int64
                        item.couponTotalCount = rec["couponTotalCount"] as? Int64
                        
                        var start = item.couponInfo?.index(of: "减")
                        start = item.couponInfo?.index(after: start!)
                        var coupon = item.couponInfo?[start!...]
                        start = coupon?.index(of: "元")
                        coupon = coupon?[..<start!]
                        let couponPrice = Float64(item.zkFinalPrice!)! - Float64(coupon!)!
                        item.couponPrice = String(format: "%.2f", arguments: [couponPrice])
                        item.numEarn = couponPrice * Float64(item.commissionRate!)! / 100
                        item.earnPrice = String(format: "%.2f", arguments: [item.numEarn!])
                        
                        item.numCoupon = Float64(String(coupon!))
                        item.numPrice = Float64(item.couponPrice!)
                    } else {
                        
                        item.numEarn = Float64(item.zkFinalPrice!)! * Float64(item.commissionRate!)! / 100
                        item.earnPrice = String(format: "%.2f", arguments: [item.numEarn!])
                        
                        item.numCoupon = 0
                        item.numPrice = Float64(item.zkFinalPrice!)
                    }
                    
                    items.append(item)
                }
                return items
            })
    }
    
    public static func getCouponTab() -> Observable<[CouponTab]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_COUPON_TAB)
            .handleResult()
            .map({ (taoKeData) -> [CouponTab] in
                var tabs: [CouponTab] = []
                for rec in (taoKeData?.getList())! {
                    let tab = CouponTab()
                    tab.cid = rec["cid"] as? String
                    tab.name = rec["name"] as? String
                    tabs.append(tab)
                }
                CouponTab.cache = tabs
                return tabs
            })
    }
    
    public static func getCouponList(cid: String) -> Observable<[CouponItem]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_COUPON_LIST.replacingOccurrences(of: "{cid}", with: cid).replacingOccurrences(of: "{pageNo}", with: "1"), auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> [CouponItem] in
                var items: [CouponItem] = []
                for rec in (taoKeData?.getList())! {
                    if let item = parseToCouponItem(rec: rec) {
                        items.append(item)
                    }
                }
                return items
            })
    }
    
    public static func searchCouponList(_ input: String) -> Observable<[CouponItem]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_SEARCH_LIST.replacingOccurrences(of: "{keyword}", with: input), auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> [CouponItem] in
                var items: [CouponItem] = []
                for rec in (taoKeData?.getList())! {
                    if let item = parseToCouponItem(rec: rec) {
                        items.append(item)
                    }
                }
                return items
            })
    }
    
    private static func parseToCouponItem(rec: [String:AnyObject]) -> CouponItem? {
        let item = CouponItem()
        
        item.couponInfo = rec["couponInfo"] as? String
        if nil == item.couponInfo {
            return nil
        }
        
        item.category = rec["category"] as? Int64
        item.couponRemainCount = rec["couponRemainCount"] as? Int64
        item.couponTotalCount = rec["couponTotalCount"] as? Int64
        item.userType = rec["userType"] as? Int64
        item.numIid = rec["numIid"] as? Int64
        item.sellerId = rec["sellerId"] as? Int64
        item.volume = rec["volume"] as? Int64
        item.smallImages = rec["smallImages"] as? [String]
        item.commissionRate = rec["commissionRate"] as? String
        item.couponClickUrl = rec["couponClickUrl"] as? String
        item.couponEndTime = rec["couponEndTime"] as? String
        item.couponStartTime = rec["couponStartTime"] as? String
        item.zkFinalPrice = rec["zkFinalPrice"] as? String
        item.itemUrl = rec["itemUrl"] as? String
        item.nick = rec["nick"] as? String
        item.pictUrl = rec["pictUrl"] as? String
        item.title = rec["title"] as? String
        item.shopTitle = rec["shopTitle"] as? String
        item.itemDescription = rec["itemDescription"] as? String
        
        var start = item.couponInfo?.index(of: "减")
        start = item.couponInfo?.index(after: start!)
        var coupon = item.couponInfo?[start!...]
        start = coupon?.index(of: "元")
        coupon = coupon?[..<start!]
        let couponPrice = Float64(item.zkFinalPrice!)! - Float64(coupon!)!
        item.couponPrice = String(format: "%.2f", arguments: [couponPrice])
        let earnPrice = couponPrice * Float64(item.commissionRate!)! / 100
        item.earnPrice = String(format: "%.2f", arguments: [earnPrice])
        
        item.numCoupon = Float64(String(coupon!))
        item.numPrice = Float64(item.couponPrice!)
        item.numEarn = Float64(item.earnPrice!)
        
        return item
    }
    
    private static func format(_ rec: [String:AnyObject], _ key: String) -> Int64? {
        if let v = rec[key] {
            return v as? Int64
        }
        return 0
    }
    
    public static func juSearchItems(_ input: String) -> Observable<[CouponItem]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_JU_SEARCH.replacingOccurrences(of: "{keyword}", with: input), auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> [CouponItem] in
                var items: [CouponItem] = []
                for rec in (taoKeData?.getList())! {
                    let item = CouponItem()
                    
                    item.category = format(rec, "tbFirstCatId")
                    item.numIid = format(rec, "itemId")
                    item.title = rec["title"] as? String
                    
                    item.pictUrl = "http:" + (rec["picUrlForWL"] as? String)!
                    item.smallImages = []
                    
                    item.itemUrl = rec["wapUrl"] as? String
                    item.couponClickUrl = rec["wapUrl"] as? String
                    
                    var desc = rec["uspDescList"] as! [String]
                    desc = desc + (rec["itemUspList"] as! [String])
                    desc = desc + (rec["priceUspList"] as! [String])
                    let buffer = NSMutableString()
                    for d in desc {
                        buffer.append(d)
                    }
                    item.itemDescription = String(buffer)
                    
                    item.zkFinalPrice = rec["origPrice"] as? String
                    item.couponPrice = rec["actPrice"] as? String
                    item.numPrice = Float64(item.couponPrice!)
                    item.couponPrice = String(format: "%.2f", arguments: [item.numPrice!])
                    item.numCoupon = Float64(item.zkFinalPrice!)! - item.numPrice!
                    item.numEarn = 0
                    item.volume = 0
                    
                    items.append(item)
                }
                return items
            })
    }
    
    public static func getShareView(_ link: String, _ title: String) -> Observable<ShareView?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_GET_SHARE_LINK, auth: (UserData.get()?.token)!, data: ["title": title, "url": link])
            .handleResult()
            .map({ (taoKeData) -> ShareView? in
                let shareView = ShareView()
                shareView.shortUrl = taoKeData?.body!["shortUrl"] as? String
                shareView.tPwd = taoKeData?.body!["tPwd"] as? String
                return shareView
            })
    }
    
    public static func getShareView2(_ images: [String], _ link: String, _ title: String) -> Observable<ShareView?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_GET_SHARE_LINK2, auth: (UserData.get()?.token)!, data: ["images": images, "title": title, "url": link])
            .handleResult()
            .map({ (taoKeData) -> ShareView? in
                let shareView = ShareView()
                shareView.shortUrl = taoKeData?.body!["shortUrl"] as? String
                shareView.tPwd = taoKeData?.body!["tPwd"] as? String
                return shareView
            })
    }
    
    public static func getNewerGuideList(_ type: Int) -> Observable<[String]?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_NOVICE_LIST.replacingOccurrences(of: "{type}", with: "\(type)"))
            .handleResult()
            .map({(taokeData) -> [String]? in
                var ret: [String] = []
                let recs = taokeData?.getList()!
                for rec in recs! {
                    ret.append(CDN + (rec["imgUrl"] as? String)!)
                }
                return ret
            })
    }
    
    public static func getBannerList() -> Observable<[HomeBtn]?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_BANNER_LIST)
            .handleResult()
            .map({ (taoKeData) -> [HomeBtn]? in
                var items: [HomeBtn] = []
                for rec in (taoKeData?.getList())! {
                    let item = HomeBtn();
                    item.name = rec["name"] as? String
                    item.ext = rec["ext"] as? String
                    item.imgUrl = CDN + (rec["imgUrl"] as? String)!
                    item.openType = rec["openType"] as! Int
                    items.append(item)
                }
                return items
            })
    }
    
    public static func getShareTemplates(_ type: Int) -> Observable<[String]?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_SHARE_APP_LIST.replacingOccurrences(of: "{type}", with: "\(type)"))
            .handleResult()
            .map({(taokeData) -> [String]? in
                var ret: [String] = []
                let recs = taokeData?.getList()!
                for rec in recs! {
                    ret.append(CDN + (rec["imgUrl"] as? String)!)
                }
                return ret
            })
    }
    
    public static func toEnroll(submit: EnrollSubmit) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_ENROLL, auth: (UserData.get()?.token)!, data: submit.toBody())
            .handleResult()
    }
    
    public static func getTeamCommition() -> Observable<[TeamDataView]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_FRIENDS_LIST, auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> [TeamDataView] in
                var result: [TeamDataView] = []
                if let recs = taoKeData?.getList() {
                    for rec in recs {
                        let item = TeamDataView()
                        item.amount = rec["commit"] as? String
                        item.name = rec["name"] as? String
                        result.append(item)
                    }
                }
                return result
            })
    }
    
    public static func countUnreadMessages() -> Observable<Int64> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_UNREAD_MSG, auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> Int64 in
                return (taoKeData?.body as? Int64)!
            })
    }
    
    public static func getMessageList(_ pageNo: Int) -> Observable<[MessageView]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_MESSAGE_LIST.replacingOccurrences(of: "{pageNo}", with: "\(pageNo)"), auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) in
                var result: [MessageView] = []
                if let recs = taoKeData?.getList() {
                    for rec in recs {
                        let item = MessageView()
                        item.id = rec["id"] as? Int64
                        item.dateStr = rec["createTime"] as? String
                        let message = rec["message"] as? [String: AnyObject]
                        item.title = message!["title"] as? String
                        item.content = message!["content"] as? String
                        result.append(item)
                    }
                }
                return result
            })
    }
    
    public static func readMessage(_ id: Int64) {
        TaoKeService.getInstance()
            .tao(api: TaoKeService.API_READ_MSG.replacingOccurrences(of: "{id}", with: "\(id)"), auth: (UserData.get()?.token)!)
            .subscribe().dispose()
    }
    
    public static func getCanDraw() -> Observable<String> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_USER_AMOUNT, auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> String in
                return (taoKeData?.body as? String)!
            })
    }
    
    public static func getThisEstimate() -> Observable<String> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_THIS_MOUNT_ESTIMATE, auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> String in
                return (taoKeData?.body as? String)!
            })
    }
    
    public static func getThatEstimate() -> Observable<String> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_LAST_MOUNT_ESTIMATE, auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> String in
                return (taoKeData?.body as? String)!
            })
    }
    
    public static func withDraw(_ amount: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_SEND_WITHDRAW.replacingOccurrences(of: "{amount}", with: amount), auth: (UserData.get()?.token)!)
            .handleResult()
    }
    
    public static func getHelpList() -> Observable<[HelpView]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_HELP_LIST)
            .handleResult()
            .map({ (taoKeData) -> [HelpView] in
                var result: [HelpView] = []
                if let recs = taoKeData?.getList() {
                    for rec in recs {
                        let item = HelpView()
                        item.title = rec["question"] as? String
                        item.title = "Q: " + (item.title ?? "")
                        item.answer = rec["answer"] as? String
                        result.append(item)
                    }
                }
                return result
            })
    }
    
    public static func report(_ input: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_REPORT, auth: (UserData.get()?.token)!, data: ["report": input])
            .handleResult()
    }
    
    public static func getOrderList(_ type: OrderFetchType, _ pageNo: Int) -> Observable<[OrderView]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_ORDER_LIST
                .replacingOccurrences(of: "{type}", with: "\(type.rawValue)")
                .replacingOccurrences(of: "{pageNo}", with: "\(pageNo)"), auth: (UserData.get()?.token)!)
            .handleResult()
            .map({ (taoKeData) -> [OrderView] in
                var result: [OrderView] = []
                if let recs = taoKeData?.getList() {
                    for rec in recs {
                        let item = OrderView()
                        item.itemName = rec["itemTitle"] as? String
                        item.itemStoreName = rec["shopTitle"] as? String
                        item.dateStr = rec["createTime"] as? String
                        item.status = rec["orderStatus"] as? String
                        item.itemTradePrice = rec["payedAmount"] as? String
                        item.commission = rec["commissionRate"] as? String
                        item.estimateIncome = rec["estimateIncome"] as? String
                        item.estimateEffect = rec["estimateEffect"] as? String
                        item.picUrl = rec["picUrl"] as? String
                        item.isSelf = rec["self"] as? Bool
                        item.teammateName = rec["teammateName"] as? String
                        result.append(item)
                    }
                }
                return result
            })
    }
    
    public static func getTopHints() -> Observable<[String]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_TOP_SEARCH)
            .handleResult()
            .map({ (taoKeData) -> [String] in
                return (taoKeData?.getStringList())!
            })
    }
    
    public static func getSearchHint(_ input: String) -> Observable<[String]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_HINT_LIST.replacingOccurrences(of: "{keyword}", with: input))
            .handleResult()
            .map({ (taoKeData) -> [String] in
                return (taoKeData?.getStringList())!
            })
    }
    
    public static func getDownloadUrl() -> Observable<String> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_DOWNLOAD_URL)
            .handleResult()
            .map({ (taoKeData) -> String in
                return taoKeData?.body as! String
            })
    }
    
    public static func getAdZoneItems() -> Observable<[AdZoneItem]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_AD_ZONE_LIST)
            .handleResult()
            .map({ (taoKeData) -> [AdZoneItem] in
                var ret:[AdZoneItem] = []
                if let list = taoKeData?.getList() {
                    for map in list {
                        let adZoneItem = AdZoneItem()
                        
                        adZoneItem.thumb = CDN + (map["imgUrl"] as! String)
                        adZoneItem.cSpan = map["colSpan"] as? Int
                        adZoneItem.rSpan = map["rowSpan"] as? Int
                        adZoneItem.name = map["name"] as? String
                        adZoneItem.ext = map["ext"] as? String
                        adZoneItem.openType = map["openType"] as? Int
                        
                        ret.append(adZoneItem)
                    }
                }
                return ret
            })
    }
    
}
