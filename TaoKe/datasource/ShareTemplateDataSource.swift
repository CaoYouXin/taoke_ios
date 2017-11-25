//
//  ShareTemplateDataSource.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/25.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import RxSwift

class ShareTemplateDataSource: RxDataSource<ShareImage> {
    
    var cache: [ShareImage]?
    
    init(viewController: UIViewController) {
        super.init(viewController)
    }
    
    override func refresh() -> Observable<[ShareImage]> {
        if cache != nil {
            return Observable.just(cache!)
        }
        
        return TaoKeApi.getShareTemplates((UserData.get()?.getShareType())!).map({ (urls) -> [ShareImage] in
            var items: [ShareImage] = []
            if let shareUrls = urls {
                for url in shareUrls {
                    let shareImage = ShareImage()
                    shareImage.thumb = url
                    shareImage.selected = false
                    items.append(shareImage)
                }
            }
            return items
        })
    }
}
