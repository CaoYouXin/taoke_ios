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
        
        taoKeData.header!["ResultCode"] = "0000" as AnyObject
        return Observable.just(taoKeData)
    }
    
    public func tao(api: String, access_taken: String, data: String, signature: String) -> Observable<TaoKeData?> {
        let taoKeData = TaoKeData()
        taoKeData.header = [:]
        taoKeData.body = [:]
        return Observable.just(taoKeData)
    }
}

