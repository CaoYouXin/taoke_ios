
import RxSwift

class TaoKeTestService: TaoKeProtocol {
    private static var instance: TaoKeProtocol?
    
    private init() {}
    
    public static func getInstance() -> TaoKeProtocol {
        if instance == nil {
            instance = TaoKeTestService()
        }
        return instance!
    }
    
    public func tao(api: String) -> Observable<TaoKeData?> {
        let taoKeData = TaoKeData()
        taoKeData.header = [:]
        taoKeData.body = [:]
        
        if api.hasPrefix(TaoKeService.API_PRODUCT_LIST) {
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let productThumbs = ["https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:                               "https:            var products: [[String:AnyObject]] = []
            for i in 0..<productThumbs.count {
                var product: [String:AnyObject] = [:]
                product["id"] = i as AnyObject
                product["title"] = "冬季毛绒沙发垫加厚保暖简约法兰绒坐垫布艺防滑沙发套沙发罩全盖" as AnyObject
                product["thumb"] = productThumbs[i] as AnyObject
                if i % 2 == 0 {
                    product["isNew"] = true as AnyObject
                } else {
                    product["isNew"] = false as AnyObject
                }
                product["price"] = "328" as AnyObject
                product["sales"] = 711 as AnyObject
                products.append(product)
            }
            taoKeData.body!["recs"] = products as AnyObject
            return Observable.just(taoKeData)
        }else if api.hasPrefix(TaoKeService.API_COUPON_DETAIL) {
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            taoKeData.body!["id"] = 0 as AnyObject
            taoKeData.body!["thumb"] = "http:            taoKeData.body!["title"] = "冬季毛绒沙发垫加厚保暖简约法兰绒坐垫布艺防滑沙发套沙发罩全盖" as AnyObject
            taoKeData.body!["priceAfter"] = "99.00" as AnyObject
            taoKeData.body!["priceBefore"] = "399.00" as AnyObject
            taoKeData.body!["sales"] = 3580 as AnyObject
            taoKeData.body!["coupon"] = "300.0" as AnyObject
            taoKeData.body!["couponRequirement"] = "398.0" as AnyObject
            taoKeData.body!["commissionPercent"] = "5.50%" as AnyObject
            taoKeData.body!["commission"] = "5.45" as AnyObject
            return Observable.just(taoKeData)
        }else if api.hasPrefix(TaoKeService.API_COUPON_SHARE_IMAGE_LIST) {
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let thumbs = ["http:            taoKeData.body!["images"] = thumbs as AnyObject
            return Observable.just(taoKeData)
        }
        
        switch api {
        case TaoKeService.API_VERIFICATION:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            return Observable.just(taoKeData)
        case TaoKeService.API_SIGN_IN:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            taoKeData.body!["access_token"] = "0000" as AnyObject
            return Observable.just(taoKeData)
        case TaoKeService.API_SIGN_UP:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            taoKeData.body!["access_token"] = "0000" as AnyObject
            return Observable.just(taoKeData)
        case TaoKeService.API_RESET_PASSWORD:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            taoKeData.body!["access_token"] = "0000" as AnyObject
            return Observable.just(taoKeData)
        case TaoKeService.API_BRAND_LIST:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let brandTitles = ["今日上新", "聚划算", "品牌券"]
            let brandThumbs = ["http:            var brandItems: [[String:AnyObject]] = []
            for i in 0..<brandTitles.count {
                var brandItem: [String:AnyObject] = [:]
                brandItem["type"] = i as AnyObject
                brandItem["title"] = brandTitles[i] as AnyObject
                brandItem["thumb"] = brandThumbs[i] as AnyObject
                brandItems.append(brandItem)
            }
            taoKeData.body!["recs"] = brandItems as AnyObject
            return Observable.just(taoKeData)
        case TaoKeService.API_COUPON_TAB:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let couponTitles = ["精选", "女装", "家居家装", "数码家电", "母婴", "食品", "鞋包配饰", "美妆个护", "男装", "内衣", "户外运动"]
            var tabs: [[String:AnyObject]] = []
            for i in 0..<couponTitles.count {
                var tab: [String:AnyObject] = [:]
                tab["type"] = i as AnyObject
                tab["title"] = couponTitles[i] as AnyObject
                tabs.append(tab)
            }
            taoKeData.body!["recs"] = tabs as AnyObject
            return Observable.just(taoKeData)
        case TaoKeService.API_COUPON_LIST:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let couponThumbs = ["http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:                                "http:            var couponItems: [[String:AnyObject]] = []
            for i in 0..<couponThumbs.count {
                var couponItem: [String:AnyObject] = [:]
                couponItem["id"] = i as AnyObject
                couponItem["thumb"] = couponThumbs[i] as AnyObject
                couponItem["title"] = "（买就送5双棉袜共10双）秋冬保暖羊毛袜男女中筒袜冬季保暖袜" as AnyObject
                couponItem["priceBefore"] = "34.90" as AnyObject
                couponItem["sales"] = 10 as AnyObject
                couponItem["priceAfter"] = "14.90" as AnyObject
                couponItem["value"] = "20" as AnyObject
                couponItem["total"] = 130000 as AnyObject
                if i % 3 == 0 {
                    couponItem["left"] = 59036 as AnyObject
                } else if i % 3 == 1 {
                    couponItem["left"] = 63036 as AnyObject
                } else {
                    couponItem["left"] = 98036 as AnyObject
                }
                couponItem["earn"] = "0.33" as AnyObject
                couponItems.append(couponItem)
            }
            taoKeData.body!["recs"] = couponItems as AnyObject
            return Observable.just(taoKeData)
        default:
            return Observable.empty()
        }
    }
    
    public func tao(api: String, access_taken: String, data: String, signature: String) -> Observable<TaoKeData?> {
        let taoKeData = TaoKeData()
        taoKeData.header = [:]
        taoKeData.body = [:]
        return Observable.just(taoKeData)
    }
}

