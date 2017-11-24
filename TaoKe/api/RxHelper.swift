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
                print("data: \(taoKeData?.toJSONString() ?? "taoke parse error")")
                let resultCode = taoKeData?.code
                if  resultCode == nil || resultCode != 2000 {
                    if resultCode == 4010 {
                        throw ApiUnAuth()
                    }
                    
                    if let message = taoKeData?.body?["msg"] as? String {
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
        return observable.observeOn(MainScheduler.instance).catchError({(error) -> Observable<T> in
            if error is ApiUnAuth {
                UserData.clear()
                UserDefaults.standard.setValue(false, forKey: IntroController.INTRO_READ)
                viewController?.navigationController?.performSegue(withIdentifier: "segue_taoke_to_splash", sender: nil)
            }
            return Observable.empty()
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

class ApiUnAuth: Error {
    init () {}
}

class ApiError: Error {
    var message: String?

    init() {

    }

    init(_ message: String?) {
        self.message = message
    }
}
