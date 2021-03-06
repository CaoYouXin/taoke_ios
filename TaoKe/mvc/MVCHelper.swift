//
//  MVCHelper.swift
//  TaoKe
//
//  Created by jason tsang on 11/13/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import CleanroomLogger
import RxSwift
import RxCocoa
import RxViewModel

class MVCHelper<T> {
    private let disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView
    
    private var cellFactory: ((UICollectionView, Int, T) -> UICollectionViewCell)?
    
    private let viewModel: RxViewModel = RxViewModel()
    
    private var dataSource: RxDataSource<T>?
    
    private var dataHook: (([T]) -> [T])?
    
    private var errorHandler: ((Error) -> Observable<[T]>)?
    
    private var data: [T] = []
    
    private var modes: [Int] = []
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func refresh() {
        viewModel.active = false
        modes = [0, 1]
        viewModel.active = true
    }
    
    func loadMore() {
        viewModel.active = false
        modes = [2]
        viewModel.active = true
    }
    
    func hasMore() -> Bool {
        return dataSource!.hasMore()
    }
    
    func set(cellFactory: ((UICollectionView, Int, T) -> UICollectionViewCell)?) {
        self.cellFactory = cellFactory
        
        var signal = viewModel.forwardSignalWhileActive(
            Observable.just(dataSource)
                .flatMap({ dataSource -> Observable<Int> in
                    return Observable.from(self.modes)
                }).flatMap{
                    mode -> Observable<[T]> in
                    switch mode {
                    case 0:
                        return self.dataSource!.loadCacheProxy()
                    case 1:
                        return self.dataSource!.refreshProxy().map({ (data) -> [T] in
                            self.data = []
                            self.data.append(contentsOf: data)
                            return self.data
                        })
                    case 2:
                        return self.dataSource!.loadMoreProxy().map({ (data) -> [T] in
                            self.data.append(contentsOf: data)
                            return self.data
                        })
                    default:
                        return Observable.empty()
                    }
        }).rxSchedulerHelper()
        
        if let handler = errorHandler {
            signal = signal.catchError({ (error) -> Observable<[T]> in
                return handler(error)
            })
        } else {
            signal = signal.catchError({ (error) -> Observable<[T]> in
                Log.error?.message(error.localizedDescription)
                return Observable.empty()
            })
        }
        
        signal = signal.flatMap({ (origin) -> Observable<[T]> in
            var data = origin
            if let hook = self.dataHook {
                data = hook(origin)
            }
            return Observable.just(data)
        })
        
        signal.bind(to: collectionView.rx.items)(cellFactory!)
            .disposed(by: disposeBag)
    }
    
    func set(dataSource: RxDataSource<T>?) {
        self.dataSource = dataSource
    }
    
    func set(dataHook: (([T]) -> [T])?) {
        self.dataHook = dataHook
    }
    
    func set(errorHandler: ((Error) -> Observable<[T]>)?) {
        self.errorHandler = errorHandler
    }
    
    func set(cellFactory: ((UICollectionView, Int, T) -> UICollectionViewCell)?, dataSource: RxDataSource<T>?, dataHook: (([T]) -> [T])?, errorHandler: ((Error) -> Observable<[T]>)?) {
        set(cellFactory: cellFactory)
        set(dataSource: dataSource)
        set(dataHook: dataHook)
        set(errorHandler: errorHandler)
    }
}
