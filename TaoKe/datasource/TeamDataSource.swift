//
//  TeamDataSource.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/28.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import RxSwift

class TeamDataSource: RxDataSource<TeamDataView> {
    override func refresh() -> Observable<[TeamDataView]> {
        return TaoKeApi.getTeamCommition()
    }
    
    override func loadMore() -> Observable<[TeamDataView]> {
        return Observable.empty()
    }
    
    override func loadCache() -> Observable<[TeamDataView]> {
        return Observable.empty()
    }
}
