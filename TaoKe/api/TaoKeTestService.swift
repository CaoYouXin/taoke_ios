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
        
        if api.hasPrefix(TaoKeService.API_COUPON_DETAIL) {
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            taoKeData.body!["id"] = 0 as AnyObject
            taoKeData.body!["thumb"] = "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg" as AnyObject
            taoKeData.body!["title"] = "冬季毛绒沙发垫加厚保暖简约法兰绒坐垫布艺防滑沙发套沙发罩全盖" as AnyObject
            taoKeData.body!["priceAfter"] = "99.00" as AnyObject
            taoKeData.body!["priceBefore"] = "399.00" as AnyObject
            taoKeData.body!["sales"] = 3580 as AnyObject
            taoKeData.body!["coupon"] = "300.0" as AnyObject
            taoKeData.body!["couponRequirement"] = "398.0" as AnyObject
            taoKeData.body!["commissionPercent"] = "5.50%" as AnyObject
            taoKeData.body!["commission"] = "5.45" as AnyObject
            return Observable.just(taoKeData)
        } else if api.hasPrefix(TaoKeService.API_PRODUCT_LIST) {
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let productThumbs = ["https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171107100244_0fbENB_yyannwong_7_11_2017_10_2_5_982.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg",
                               "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171012073213_p4H630_joycechu_syc_12_10_2017_7_32_7_433.jpeg", "https://ws1.sinaimg.cn/large/610dc034ly1fk05lf9f4cj20u011h423.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjppsiclufj20u011igo5.jpg", "https://ws1.sinaimg.cn/large/610dc034ly1fjfae1hjslj20u00tyq4x.jpg"]
            var products: [[String:AnyObject]] = []
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
        }
        
        switch api {
        case TaoKeService.API_BRAND_LIST:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let brandTitles = ["今日上新", "聚划算", "品牌券"]
            let brandThumbs = ["http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg"]
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
        case TaoKeService.API_COUPON_LIST:
            taoKeData.header!["ResultCode"] = "0000" as AnyObject
            let couponThumbs = ["http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg",
                                "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171024083526_Hq4gO6_bluenamchu_24_10_2017_8_34_28_246.jpeg", "http://7xi8d6.com1.z0.glb.clouddn.com/20171018091347_Z81Beh_nini.nicky_18_10_2017_9_13_35_727.jpeg"]
            var couponItems: [[String:AnyObject]] = []
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

