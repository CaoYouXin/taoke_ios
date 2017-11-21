//
//  RxHelper.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RxSwift
import Toast_Swift

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
                        throw ApiError(message)
                    } else {
                        throw ApiError()
                    }
                }
            }
            return data
        }
    }
}

class ApiErrorHook: Hook {
    func hook<T>(viewController: UIViewController?, observable: Observable<T>) -> Observable<T> {
        return observable.observeOn(MainScheduler.instance).map({ (data) -> T in
            if let controller = viewController {
                controller.view.makeToast("This is a api error hook", duration: 3.0, position: .center)
            }
            return data
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

class ApiError: Error {
    var message: String?

    init() {

    }

    init(_ message: String?) {
        self.message = message
    }
}
