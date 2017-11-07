//
//  TaoKeService.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RestKit
import RxSwift

class TaoKeService: TaoKeProtocol {
    func tao(api: String) -> Observable<TaoKeData?> {
        return Observable.empty()
    }
    
    func tao(api: String, access_taken: String, data: String, signature: String) -> Observable<TaoKeData?> {
        return Observable.empty()
    }
}
