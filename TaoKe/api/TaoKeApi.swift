//
//  TaoKeApi.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RxSwift

class TaoKeApi {
    public static func verification(phone: String) -> Observable<TaoKeData?> {
        return TaoKeService.getInstance()
            .tao(api: TaoKeService.API_VERIFICATION)
            .handleResult()
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
}
