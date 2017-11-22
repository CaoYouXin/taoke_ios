//
//  TaoKeProtocol.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RxSwift

protocol TaoKeProtocol {
    
    func tao(api: String) -> Observable<TaoKeData?>
    
    func tao(api: String, auth: String) -> Observable<TaoKeData?>
    
    func tao(api: String, auth: String, data: Dictionary<String, Any>) -> Observable<TaoKeData?>
    
    static func getInstance() -> TaoKeProtocol
    
}
