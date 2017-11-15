//
//  ProductDataSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/15/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift

class ProductDataSource: RxDataSource<Product> {
    public static let SORT_MULTIPLE = 0
    public static let SORT_SALES = 1
    public static let SORT_PRICE_UP = 2
    public static let SORT_PRICE_DOWN = 3
    public static let SORT_COMMISSION = 4
    
    var brandItem: BrandItem
    
    var sort: Int = 0
    
    init(_ brandItem: BrandItem) {
        self.brandItem = brandItem
    }
    
    func set(_ sort: Int) {
        self.sort = sort
    }
    
    override func refresh() -> Observable<[Product]> {
        return TaoKeApi.getProductList(brandItem)
    }
}
