//
//  TaoKeApi.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RxSwift

class TaoKeApi {
    public static let DEFAULT_ACCESS_TOKEN = "token"

    private static var token: String?

    public static func cacheToken() {
        UserDefaults.standard.setValue(token, forKey: TaoKeApi.DEFAULT_ACCESS_TOKEN)
    }

    public static func restoreToken() -> Bool {
        if let token = UserDefaults.standard.string(forKey: TaoKeApi.DEFAULT_ACCESS_TOKEN) {
            TaoKeApi.token = token
            return true
        } else {
            return false
        }
    }

    public static func clearToken() {
        UserDefaults.standard.removeObject(forKey: TaoKeApi.DEFAULT_ACCESS_TOKEN)
    }

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
                token = taoKeData?.body?["access_token"] as? String
                cacheToken()
                return taoKeData
            })
    }

    public static func signIn(phone: String, password: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_SIGN_IN)
            .handleResult()
            .map({ (taoKeData) -> TaoKeData? in
                token = taoKeData?.body?["access_token"] as? String
                cacheToken()
                return taoKeData
            })
    }

    public static func resetPassword(phone: String, verificationCode: String, password: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_RESET_PASSWORD)
            .handleResult()
            .map({ (taoKeData) -> TaoKeData? in
                token = taoKeData?.body?["access_token"] as? String
                cacheToken()
                return taoKeData
            })
    }

    public static func getBrandList() -> Observable<[BrandItem]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_BRAND_LIST)
            .handleResult()
            .map({ (taoKeData) -> [BrandItem] in
                var items: [BrandItem] = []
                if let recs = taoKeData?.body?["recs"] as? [[String: AnyObject]] {
                    for rec in recs {
                        let item = BrandItem()
                        item.type = rec["type"] as? Int
                        item.title = rec["title"] as? String
                        item.thumb = rec["thumb"] as? String
                        items.append(item)
                    }
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
                if let recs = taoKeData?.body?["recs"] as? [[String: AnyObject]] {
                    for rec in recs {
                        let tab = CouponTab()
                        tab.type = rec["type"] as? Int
                        tab.title = rec["title"] as? String
                        tabs.append(tab)
                    }
                }
                return tabs
            })
    }

    public static func getCouponList() -> Observable<[CouponItem]> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_COUPON_LIST)
            .handleResult()
            .map({ (taoKeData) -> [CouponItem] in
                var items: [CouponItem] = []
                if let recs = taoKeData?.body?["recs"] as? [[String: AnyObject]] {
                    for rec in recs {
                        let item = CouponItem()
                        item.id = rec["id"] as? Int
                        item.thumb = rec["thumb"] as? String
                        item.title = rec["title"] as? String
                        item.priceBefore = rec["priceBefore"] as? String
                        item.sales = rec["sales"] as? Int
                        item.priceAfter = rec["priceAfter"] as? String
                        item.value = rec["value"] as? String
                        item.total = rec["total"] as? Int
                        item.left = rec["left"] as? Int
                        item.earn = rec["earn"] as? String
                        items.append(item)
                    }
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

    public static func getNewerGuideList() -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_NOVICE_LIST)
            .handleResult()
}
