//
//  RxHelper.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RxSwift

extension ObservableType {
    public func rxSchedulerHelper() -> Observable<Self.E> {
        return self.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    public func handleResult() -> Observable<Self.E> {
        return self.map { data -> Self.E in
            if data is TaoKeData {
                let taoKeData = data as? TaoKeData
                let resultCode = taoKeData?.code
                if  resultCode == nil || resultCode != 2000 {
                    if let message = taoKeData?.body?["msg"] as? String {
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
