//
//  HelpDataSource.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/30.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import RxSwift

class HelpDataSource: RxDataSource<HelpView> {
    
    override func refresh() -> Observable<[HelpView]> {
        return TaoKeApi.getHelpList()
    }
    
    override func loadMore() -> Observable<[HelpView]> {
        return Observable.empty()
    }
    
    override func loadCache() -> Observable<[HelpView]> {
        return Observable.empty()
    }
}
