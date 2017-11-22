//
//  TaoKeData.swift
//  TaoKe
//
//  Created by jason tsang on 11/7/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import HandyJSON

class TaoKeData: NSObject, HandyJSON {
    @objc public dynamic var code: Int = 0
    @objc public dynamic var body: AnyObject?
    
    func getList() -> [Dictionary<String, AnyObject>]? {
        return self.body as? [Dictionary<String, AnyObject>]
    }
    
    func getMap() -> Dictionary<String, AnyObject>? {
        return self.body as? Dictionary<String, AnyObject>
    }
    
    func getStringList() -> [String]? {
        return self.body as? [String]
    }
    
    override required init() {}
}
