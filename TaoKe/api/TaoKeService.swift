
import RestKit
import RxSwift

class TaoKeService: TaoKeProtocol {

    public static let API_VERIFICATION = "tbk/phone/verify"
    public static let API_SIGN_IN = "tbk/user/login"
    public static let API_SIGN_UP = "tbk/user/register"
    public static let API_RESET_PASSWORD = "tbk/user/reset/pwd"

    public static let API_BANNER_LIST = "home/banner/list"
    public static let API_COUPON_TAB = "home/cate/list"
    public static let API_BRAND_LIST = "home/group/list"

    public static let API_HINT_LIST = "tbk/hints/{keyword}"
    public static let API_SEARCH_LIST = "tbk/search/{keyword}"
    public static let API_TOP_SEARCH = "tbk/hints/top"
    public static let API_JU_SEARCH = "tbk/ju/{keyword}";

    public static let API_MESSAGE_LIST = "msg/list/{pageNo}"
    public static let API_UNREAD_MSG = "msg/unread/count"
    public static let API_REPORT = "msg/feedback"
    public static let API_READ_MSG = "msg/read/{id}"

    public static let API_FRIENDS_LIST = "tbk/team/list"
    public static let API_COUPON_LIST = "tbk/coupon/{cid}/{pageNo}"
    public static let API_PRODUCT_LIST = "tbk/fav/{favId}/list/{pageNo}"
    public static let API_ORDER_LIST = "tbk/order/list/{type}/{pageNo}"
    public static let API_GET_SHARE_LINK = "tbk/url/trans"

    public static let API_HELP_LIST = "app/help/list"
    public static let API_NOVICE_LIST = "app/guide/list/{type}"
    public static let API_SHARE_APP_LIST = "app/share/img/url/list/{type}"

    public static let API_SEND_WITHDRAW = "tbk/withdraw/{amount}"
    public static let API_USER_AMOUNT = "tbk/candraw"
    public static let API_THIS_MOUNT_ESTIMATE = "tbk/estimate/this"
    public static let API_LAST_MOUNT_ESTIMATE = "tbk/estimate/that"

    public static let API_ENROLL = "tbk/user/apply/4/agent"
    public static let API_DOWNLOAD_URL = "app/download/url"

//    public static let HOST = "http://192.168.0.136:8080/api/"
    public static let HOST = "http://server.tkmqr.com:8080/api/"

    private static var instance: TaoKeProtocol?

    private var manager: RKObjectManager?

    private init() {
        let requestDataMapping = RKObjectMapping(for: NSMutableDictionary.self)
        requestDataMapping?.addAttributeMappings(from: ["phone", "pwd", "title", "url", "smsCode", "code", "invitation", "user", "realName", "aliPayId", "qqId", "weChatId", "announcement", "report"])
        let requestDescriptor = RKRequestDescriptor(mapping: requestDataMapping, objectClass: NSMutableDictionary.self, rootKeyPath: nil, method: .POST)

        let taoKeDataMapping = RKObjectMapping(for: TaoKeData.self)
        taoKeDataMapping?.addAttributeMappings(from: ["code", "body"])
        let responseDescriptor = RKResponseDescriptor(mapping: taoKeDataMapping, method: .any, pathPattern: nil, keyPath: nil, statusCodes: nil)

        manager = RKObjectManager(baseURL: URL(string: TaoKeService.HOST))
        manager?.addRequestDescriptor(requestDescriptor)
        manager?.addResponseDescriptor(responseDescriptor)
        manager?.requestSerializationMIMEType = RKMIMETypeJSON
        
        manager?.httpClient.setDefaultHeader("platform", value: "ios")
        manager?.httpClient.setDefaultHeader("version", value: "1.0.0")
    }

    public static func getInstance() -> TaoKeProtocol {
        if instance == nil {
            instance = TaoKeService()
        }
        return instance!
    }

    public func tao(api: String) -> Observable<TaoKeData?> {
        return Observable.create { (observer) -> Disposable in
            self.manager?.getObjectsAtPath(api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), parameters: nil, success: { (operation, result) in
                observer.onNext(result?.firstObject as? TaoKeData)
                observer.onCompleted()
            }, failure: { (operation, error) in
                observer.onError(error!)
            })
            return Disposables.create()
        }
    }

    public func tao(api: String, auth: String) -> Observable<TaoKeData?> {
        self.manager?.httpClient.setDefaultHeader("auth", value: auth)
        return Observable.create { (observer) -> Disposable in
            self.manager?.getObjectsAtPath(api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), parameters: nil, success: { (operation, result) in
                observer.onNext(result?.firstObject as? TaoKeData)
                observer.onCompleted()
            }, failure: { (operation, error) in
                observer.onError(error!)
            })
            return Disposables.create()
        }
    }

    public func tao(api: String, auth: String, data: NSMutableDictionary) -> Observable<TaoKeData?> {
        self.manager?.httpClient.setDefaultHeader("auth", value: auth)
        return Observable.create({ (observer) -> Disposable in
            self.manager?.post(data, path: api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), parameters: nil, success: { (operation, result) in
                observer.onNext(result?.firstObject as? TaoKeData)
                observer.onCompleted()
            }, failure: { (operation, error) in
                observer.onError(error!)
            })
            return Disposables.create()
        })
    }
    
}
