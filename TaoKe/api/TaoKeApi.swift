//
//  TaoKeApi.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RxSwift

class TaoKeApi {

//    private static var CDN = "http://192.168.0.115:8070/"
    private static var CDN = "http://server.tkmqr.com:8070/"

    public static func verification(phone: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_VERIFICATION)
            .handleResult()
    }

    public static func signUp(phone: String, verificationCode: String, password: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_SIGN_UP)
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
            .tao(api: TaoKeService.API_RESET_PASSWORD)
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
                    item.openType = rec["openType"] as? Int
                    items.append(item)
                }
                return items
            })
    }

    public static func getProductList(_ brandItem: BrandItem) -> Observable<[Product]> {
        return TaoKeService.getInstance()
            .tao(api: "\(TaoKeService.API_PRODUCT_LIST)/\(brandItem.type!)")
            .handleResult()
            .map({ (taoKeData) -> [Product] in
                var items: [Product] = []
                if let recs = taoKeData?.body?["recs"] as? [[String: AnyObject]] {
                    for rec in recs {
                        let item = Product()
                        item.id = rec["id"] as? Int
                        item.title = rec["title"] as? String
                        item.thumb = rec["thumb"] as? String
                        item.isNew = rec["isNew"] as? Bool
                        item.price = rec["price"] as? String
                        item.sales = rec["sales"] as? Int
                        items.append(item)
                    }
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
                        let item = CouponItem()
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
                        item.couponInfo = rec["couponInfo"] as? String
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
                        
                        items.append(item)
                    }
                return items
            })
    }

    public static func getCouponDetail(_ couponItem: CouponItem) -> Observable<CouponItemDetail> {
        return TaoKeService.getInstance()
            .tao(api: "")
            .handleResult()
            .map({ (taoKeData) -> CouponItemDetail in
                let couponItemDetail = CouponItemDetail()
                couponItemDetail.thumb = taoKeData?.body?["thumb"] as? String
                couponItemDetail.title = taoKeData?.body?["title"] as? String
                couponItemDetail.priceBefore = taoKeData?.body?["priceBefore"] as? String
                couponItemDetail.priceAfter = taoKeData?.body?["priceAfter"] as? String
                couponItemDetail.sales = taoKeData?.body?["sales"] as? Int
                couponItemDetail.coupon = taoKeData?.body?["coupon"] as? String
                couponItemDetail.couponRequirement = taoKeData?.body?["couponRequirement"] as? String
                couponItemDetail.commissionPercent = taoKeData?.body?["commissionPercent"] as? String
                couponItemDetail.commission = taoKeData?.body?["commission"] as? String
                return couponItemDetail
            })
    }

    public static func getCouponShareImageList(_ couponItem: CouponItem) -> Observable<[String]?> {
        return TaoKeService.getInstance()
            .tao(api: "")
            .handleResult()
            .map({ (taoKeData) -> [String]? in
                return taoKeData?.body?["images"] as? [String]
            })
    }

    public static func getNewerGuideList() -> Observable<[String]?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_NOVICE_LIST)
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
                    item.openType = rec["openType"] as? Int
                    items.append(item)
                }
                return items
            })
    }
    
}
