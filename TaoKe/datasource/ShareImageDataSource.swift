//
//  ShareImageDataSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/16/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift

class ShareImageDataSource: RxDataSource<ShareImage> {
    private var couponItem: CouponItem?
    
    init(viewController: UIViewController, couponItem: CouponItem?) {
        self.couponItem = couponItem
        super.init(viewController)
    }
    
    func set(_ couponItem: CouponItem?) {
        self.couponItem = couponItem
    }
    
    override func refresh() -> Observable<[ShareImage]> {
        let shareImage = ShareImage()
        shareImage.thumb = couponItem?.pictUrl
        shareImage.selected = true
        var shareImages: [ShareImage] = [shareImage]
        
        for image in (couponItem?.smallImages)! {
            let shareImage = ShareImage()
            shareImage.thumb = image
            shareImage.selected = false
            shareImages.append(shareImage)
        }
        
        return Observable.just(shareImages)
    }
}
