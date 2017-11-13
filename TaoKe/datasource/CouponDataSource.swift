//
//  couponDataSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/13/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift

class CouponDataSource: RxDataSource<CouponItem> {
    var type: Int = 0
    
    func set(_ type: Int) {
        self.type = type
    }
    
    override func refresh() -> Observable<[CouponItem]> {
        return TaoKeApi.getCouponList()
    }
    
    override func loadMore() -> Observable<[CouponItem]> {
        return TaoKeApi.getCouponList().map({ (items) -> [CouponItem] in
            var newItems: [CouponItem] = []
            newItems.append(items[0])
            return newItems
        })
    }
}
