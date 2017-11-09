//
//  TaoKeTestService.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

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
        
        switch api {
        case TaoKeService.API_BRAND_LIST:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let brandTitles = ["今日上新", "聚划算", "品牌券", "品牌券", "品牌券", "品牌券", "品牌券", "品牌券", "品牌券", "品牌券", "品牌券", "品牌券", "品牌券", "品牌券"]
            let brandThumbs = ["http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg"]
            var brandItems: [[String:AnyObject]] = []
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

