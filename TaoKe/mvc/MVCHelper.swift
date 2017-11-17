//
//  MVCHelper.swift
//  TaoKe
//
//  Created by jason tsang on 11/13/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift
import RxCocoa
import RxViewModel

class MVCHelper<T> {
    private let disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView
    
    private var cellFactory: ((UICollectionView, Int, T) -> UICollectionViewCell)?
    
    private let viewModel: RxViewModel = RxViewModel()
    
    private var dataSource: RxDataSource<T>?
    
    private var data: [T] = []
    
    private var mode = 0
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func refresh() {
        viewModel.active = false
        mode = 1
        viewModel.active = true
    }
    
    func loadMore() {
        viewModel.active = false
        mode = 2
        viewModel.active = true
    }
    
    func hasMore() -> Bool {
        return dataSource!.hasMore()
    }
    
    func set(cellFactory: ((UICollectionView, Int, T) -> UICollectionViewCell)?) {
        self.cellFactory = cellFactory
        
        viewModel.forwardSignalWhileActive(
            Observable.just(refresh).flatMap{
                refresh -> Observable<[T]> in
                switch self.mode {
                case 0:
                    return self.dataSource!.loadCache()
                case 1:
                    return self.dataSource!.refresh().map({ (data) -> [T] in
                        self.data = []
                        self.data.append(contentsOf: data)
                        return self.data
                    })
                case 2:
                    return self.dataSource!.loadMore().map({ (data) -> [T] in
                        self.data.append(contentsOf: data)
                        return self.data
                    })
                default:
                    return Observable.empty()
                }
        }).rxSchedulerHelper()
            .bind(to: collectionView.rx.items)(cellFactory!)
            .disposed(by: disposeBag)
    }
    
    func set(cellFactory: ((UICollectionView, Int, T) -> UICollectionViewCell)?, dataHook: @escaping (([T]) throws -> [T])) {
        self.cellFactory = cellFactory
        viewModel.forwardSignalWhileActive(
            Observable.just(refresh).flatMap{
                refresh -> Observable<[T]> in
                switch self.mode {
                case 0:
                    return self.dataSource!.loadCache()
                case 1:
                    return self.dataSource!.refresh().map({ (data) -> [T] in
                        self.data = []
                        self.data.append(contentsOf: data)
                        return self.data
                    })
                case 2:
                    return self.dataSource!.loadMore().map({ (data) -> [T] in
                        self.data.append(contentsOf: data)
                        return self.data
                    })
                default:
                    return Observable.empty()
                }
        }).rxSchedulerHelper()
            .map(dataHook)
            .bind(to: collectionView.rx.items)(cellFactory!)
            .disposed(by: disposeBag)
    }
    
    func set(dataSource: RxDataSource<T>?) {
        self.dataSource = dataSource
    }
}
