//
//  RegExpUtil.swift
//  TaoKe
//
//  Created by jason tsang on 11/20/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

class RegExpUtil {
    public static func isPhoneNo(phoneNo: String) -> Bool {
        if phoneNo.utf16.count == 0 {
            return false
        }
        
        let mobile = "^1\\d{10}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        
        return regexMobile.evaluate(with: phoneNo)
    }
}
