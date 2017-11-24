//
//  ProductDataSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/15/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift

class ProductDataSource: RxDataSource<CouponItem> {
    public static let SORT_MULTIPLE = 0
    public static let SORT_SALES = 1
    public static let SORT_PRICE_UP = 2
    public static let SORT_PRICE_DOWN = 3
    public static let SORT_COMMISSION = 4
    
    private var homeBtn: HomeBtn?
    
    private var sort: Int = 0
    
    init(viewController: UIViewController, homeBtn: HomeBtn?) {
        self.homeBtn = homeBtn
        super.init(viewController)
    }
    
    func set(_ sort: Int) {
        self.sort = sort
    }
    
    override func refresh() -> Observable<[CouponItem]> {
        return TaoKeApi.getProductList((homeBtn?.ext)!)
    }
}
