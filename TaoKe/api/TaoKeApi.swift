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
