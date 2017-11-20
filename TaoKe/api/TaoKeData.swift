//
//  TaoKeData.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import HandyJSON

class TaoKeData: NSObject, HandyJSON {
    public var code: Int?
    public var body: Dictionary<String, Any>?
    
    override required init() {}
}
