
import CleanroomLogger
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
                let resultCode = taoKeData?.code
                if  resultCode == nil || resultCode != 2000 {
                    if resultCode == 4010 {
                        throw ApiUnAuth()
                    }
                    
                    if resultCode == 5010 {
                        throw ApiVersionLow()
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
    
public func handleApiError(_ viewController: UIViewController?, _ callback: ((Error) -> Void)? = nil) -> Observable<Self.E> {
        return self.observeOn(MainScheduler.instance).catchError({(error) -> Observable<Self.E> in
            if error is ApiUnAuth, let view = viewController {
                let alert = UIAlertController(title: "", message: "您需要重新登录", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { (action) in
                    UserData.clear()
                    view.navigationController?.performSegue(withIdentifier: "segue_taoke_to_splash", sender: nil)
                }))
                view.present(alert, animated: true)
            }
            
            if error is ApiVersionLow, let view = viewController {
                let alert = UIAlertController(title: "", message: "您需要重新登录", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { (action) in
                    let _ = TaoKeApi.getDownloadUrl().subscribe(onNext: { (downloadUrl) in
                        let url = URL(string: downloadUrl)
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!, options: [:])
                        }
                    })
                }))
                view.present(alert, animated: true)
            }
            
            if let err = error as? ApiError {
                if let cb = callback {
                    cb(error)
                }
                
                let errMsg = err.message ?? ""
                Log.error?.message(errMsg)
                if let view = viewController {
                    view.view.makeToast(errMsg)
                }
            } else {
                
                let errMsg = "操作失败,错误未知"
                Log.error?.message(errMsg)
                if let view = viewController {
                    view.view.makeToast(errMsg)
                }
            }
            
            return Observable.empty()
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

class ApiErrorHook: Hook {
    func hook<T>(viewController: UIViewController?, observable: Observable<T>) -> Observable<T> {
        return observable.observeOn(MainScheduler.instance).catchError({(error) -> Observable<T> in
            if error is ApiUnAuth, let view = viewController {
                let alert = UIAlertController(title: "", message: "您需要重新登录", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { (action) in
                    UserData.clear()
                    view.navigationController?.performSegue(withIdentifier: "segue_taoke_to_splash", sender: nil)
                }))
                view.present(alert, animated: true)
            }
            
            if error is ApiVersionLow, let view = viewController {
                let alert = UIAlertController(title: "", message: "您当前版本过低，为了更好的使用觅券儿，请立刻升级！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "去下载", style: .default, handler: { (action) in
                    let _ = TaoKeApi.getDownloadUrl().subscribe(onNext: { (downloadUrl) in
                        let url = URL(string: downloadUrl)
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(url!, options: [:])
                        }
                    })
                }))
                view.present(alert, animated: true)
            }
            
            return Observable.empty()
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

class ApiUnAuth: Error {
    init () {}
}

class ApiVersionLow: Error {
    init () {}
}

class ApiError: Error {
    public var message: String?
    
    init() {
        
    }
    
    init(_ message: String?) {
        self.message = message
    }
}
