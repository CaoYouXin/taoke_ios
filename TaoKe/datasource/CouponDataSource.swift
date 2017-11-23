//
//  couponDataSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/13/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift

class CouponDataSource: RxDataSource<CouponItem> {
    private var cid: String?
    
    func set(cid: String) {
        self.cid = cid
    }
    
    override func refresh() -> Observable<[CouponItem]> {
        return TaoKeApi.getCouponList(cid: self.cid!)
    }
    
    override func loadMore() -> Observable<[CouponItem]> {
        return Observable.just([])
    }
}
