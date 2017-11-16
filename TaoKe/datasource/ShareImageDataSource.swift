//
//  ShareImageDataSource.swift
//  TaoKe
//
//  Created by jason tsang on 11/16/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift

class ShareImageDataSource: RxDataSource<ShareImage> {
    private var couponItem: CouponItem
    
    init(_ couponItem: CouponItem) {
        self.couponItem = couponItem
    }
    
    override func refresh() -> Observable<[ShareImage]> {
        return TaoKeApi.getCouponShareImageList(couponItem)
            .map({
                images in
                var shareImages: [ShareImage] = []
                if(images != nil) {
                    for image in images! {
                        let shareImage = ShareImage()
                        shareImage.thumb = image
                        shareImage.selected = false
                        shareImages.append(shareImage)
                    }
                }
                return shareImages
            })
    }
}
