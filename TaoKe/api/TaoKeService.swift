//
//  TaoKeService.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RestKit
import RxSwift

class TaoKeService: TaoKeProtocol {
    public static let API_VERIFICATION = "verification"
    public static let API_BRAND_LIST = "brandList"
    public static let API_COUPON_TAB = "couponTab"
    public static let API_COUPON_LIST = "couponList"
    
    public static let HOST = "https://127.0.0.1:8081"
    
    private static var instance: TaoKeProtocol?
    
    private var manager: RKObjectManager?
    
    private init() {
        let requestDataMapping = RKObjectMapping(for: NSMutableDictionary.self)
        requestDataMapping?.addAttributeMappings(from: ["access_taken", "data", "signature"])
        let requestDescriptor = RKRequestDescriptor(mapping: requestDataMapping, objectClass: NSMutableDictionary.self, rootKeyPath: nil, method: .POST)
        
        let taoKeDataMapping = RKObjectMapping(for: TaoKeData.self)
        taoKeDataMapping?.addAttributeMappings(from: ["header", "body"])
        
        let responseDescriptor = RKResponseDescriptor(mapping: taoKeDataMapping, method: .any, pathPattern: nil, keyPath: nil, statusCodes: nil)
        
        manager = RKObjectManager(baseURL: URL(string: TaoKeService.HOST))
        manager?.addRequestDescriptor(requestDescriptor)
        manager?.addResponseDescriptor(responseDescriptor)
    }
    
    public static func getInstance() -> TaoKeProtocol {
        if instance == nil {
            //instance = TaoKeService()
            instance = TaoKeTestService.getInstance()
        }
        return instance!
    }
    
    public func tao(api: String) -> Observable<TaoKeData?> {
        return Observable.create { (observer) -> Disposable in
            self.manager?.getObjectsAtPath(("/api/\(api)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), parameters: nil, success: { (operation, result) in
                observer.onNext(result?.firstObject as? TaoKeData)
                observer.onCompleted()
            }, failure: { (operation, error) in
                observer.onError(error!)
            })
            return Disposables.create()
        }
    }
    
    public func tao(api: String, access_taken: String, data: String, signature: String) -> Observable<TaoKeData?> {
        return Observable.create({ (observer) -> Disposable in
            self.manager?.post(NSMutableDictionary(dictionary: ["access_taken": access_taken, "data": data, "signature": signature], copyItems: true), path: "/api/\(api)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), parameters: nil, success: { (operation, result) in
                observer.onNext(result?.firstObject as? TaoKeData)
                observer.onCompleted()
            }, failure: { (operation, error) in
                observer.onError(error!)
            })
            return Disposables.create()
        })
    }
}
