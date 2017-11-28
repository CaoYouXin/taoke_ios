//
//  MessageDataSource.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/28.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import RxSwift

class MessageDataSource: RxDataSource<MessageView> {
    
    private var pageNo = 1
    
    override func refresh() -> Observable<[MessageView]> {
        pageNo = 1
        return TaoKeApi.getMessageList(pageNo)
    }
    
    override func loadMore() -> Observable<[MessageView]> {
        pageNo = pageNo + 1
        return TaoKeApi.getMessageList(pageNo)
    }
    
    override func loadCache() -> Observable<[MessageView]> {
        return Observable.empty()
    }
}
