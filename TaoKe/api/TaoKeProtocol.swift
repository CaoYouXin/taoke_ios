//
//  TaoKeProtocol.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RxSwift

protocol TaoKeProtocol {
    func tao(api: String) -> Observable<TaoKeData?>
    
    func tao(api: String, access_taken: String, data: String, signature: String) -> Observable<TaoKeData?>
    
    static func getInstance() -> TaoKeProtocol
}

extension ObservableType {
    public func rxSchedulerHelper() -> Observable<Self.E> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    public func handleResult() -> Observable<Self.E> {
        return self.map { data -> Self.E in
            if data is TaoKeData {
                let taoKeData = data as? TaoKeData
                let resultCode = taoKeData?.header?["ResultCode"] as? String
                if  resultCode == nil || resultCode!.compare("0000").rawValue != 0 {
                    if let message = taoKeData?.header?["Message"] as? String {
                        throw ApiError(message: message)
                    } else {
                        throw ApiError()
                    }
                }
            }
            return data
        }
    }
}

class ApiError: Error {
    init() {
        
    }
    
    init(message: String) {
 
    }
}
