//
//  RxDataSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/13/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift

protocol RxDataSourceProtocol {
    associatedtype Element
    func refresh() -> Observable<[Self.Element]>
    func loadMore() -> Observable<[Self.Element]>
    func loadCache() -> Observable<[Self.Element]>
    func hasMore() -> Bool
}

class RxDataSource<T>: RxDataSourceProtocol {
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
