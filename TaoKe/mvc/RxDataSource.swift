//
//  RxDataSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/13/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift

class RxDataSource<T> {
    private var viewController: UIViewController?
    
    init(_ viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func set(_ viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func refreshProxy() -> Observable<[T]> {
        var observable = refresh()
        for hook in RxDataHook.hooks {
            observable = hook.hook(viewController: viewController, observable: observable)
        }
        return observable
    }
    
    func loadMoreProxy() -> Observable<[T]> {
        var observable = loadMore()
        for hook in RxDataHook.hooks {
            observable = hook.hook(viewController: viewController, observable: observable)
        }
        return observable
    }
    
    func loadCacheProxy() -> Observable<[T]> {
        var observable = loadCache()
        for hook in RxDataHook.hooks {
            observable = hook.hook(viewController: viewController, observable: observable)
        }
        return observable
    }
    
    func refresh() -> Observable<[T]> {
        return Observable.empty()
    }
    
    func loadMore() -> Observable<[T]> {
        return Observable.empty()
    }
    
    func loadCache() -> Observable<[T]> {
        return Observable.empty()
    }
    
    func hasMore() -> Bool {
        return false
    }
}

class RxDataHook {
    fileprivate static var hooks: [Hook] = []
    
    static func add(_ hook: Hook) {
        hooks.append(hook)
    }
}

protocol Hook {
    func hook<T>(viewController: UIViewController?, observable: Observable<T>) -> Observable<T>
}
