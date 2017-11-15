//
//  BrandDateSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/15/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RxSwift

class BrandDataSource: RxDataSource<BrandItem> {
    
    override func refresh() -> Observable<[BrandItem]> {
        return TaoKeApi.getBrandList()
    }
    
}
