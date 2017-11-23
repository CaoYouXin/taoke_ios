//
// Created by CaoYouxin on 2017/11/23.
// Copyright (c) 2017 jason tsang. All rights reserved.
//

import Foundation

class UserData {

    private static let DEFAULT_TOKEN = "token"
    private static let DEFAULT_USER = "user";
    private static let DEFAULT_USER_NAME = "name";
    private static let DEFAULT_USER_PID = "aliPid";
    private static let DEFAULT_USER_ID = "id";
    private static let DEFAULT_USER_SHARE_CODE = "code";
    private static let DEFAULT_CANDIDATE = "candidate";

    public var token: String?
    public var name: String?
    public var pid: String?
    public var userId: Int64?
    public var candidate: Bool?
    public var shareCode: String?

    private static var instance: UserData?

    public static func get() -> UserData? {
        return instance
    }

    public static func set(from: TaoKeData?) -> UserData? {
        instance = UserData()
        instance!.token = from?.body![DEFAULT_TOKEN] as? String
        instance!.candidate = from?.body![DEFAULT_CANDIDATE] as? Bool
        let user = from?.body![DEFAULT_USER] as? AnyObject
        instance!.userId = user![DEFAULT_USER_ID] as? Int64
        instance!.name = user![DEFAULT_USER_NAME] as? String
        instance!.pid = user![DEFAULT_USER_PID] as? String
        instance!.shareCode = user![DEFAULT_USER_SHARE_CODE] as? String
        return instance
    }

    public static func restore() -> Bool {
        if let token = UserDefaults.standard.string(forKey: UserData.DEFAULT_TOKEN) {
            instance = UserData()
            instance!.token = token
            instance!.candidate = UserDefaults.standard.bool(forKey: UserData.DEFAULT_CANDIDATE)
            instance!.userId = UserDefaults.standard.object(forKey: UserData.DEFAULT_USER_ID) as? Int64
            instance!.name = UserDefaults.standard.string(forKey: UserData.DEFAULT_USER_NAME)
            instance!.pid = UserDefaults.standard.string(forKey: UserData.DEFAULT_USER_PID)
            instance!.shareCode = UserDefaults.standard.string(forKey: UserData.DEFAULT_USER_SHARE_CODE)
            return true
        } else {
            return false
        }
    }

    public static func clear() {
        UserDefaults.standard.removeObject(forKey: UserData.DEFAULT_TOKEN)
        UserDefaults.standard.removeObject(forKey: UserData.DEFAULT_CANDIDATE)
        UserDefaults.standard.removeObject(forKey: UserData.DEFAULT_USER_ID)
        UserDefaults.standard.removeObject(forKey: UserData.DEFAULT_USER_NAME)
        UserDefaults.standard.removeObject(forKey: UserData.DEFAULT_USER_PID)
        UserDefaults.standard.removeObject(forKey: UserData.DEFAULT_USER_SHARE_CODE)
    }

    public func cache() {
        UserDefaults.standard.setValue(self.token, forKey: UserData.DEFAULT_TOKEN)
        UserDefaults.standard.setValue(self.candidate, forKey: UserData.DEFAULT_CANDIDATE)
        UserDefaults.standard.setValue(self.userId, forKey: UserData.DEFAULT_USER_ID)
        UserDefaults.standard.setValue(self.name, forKey: UserData.DEFAULT_USER_NAME)
        UserDefaults.standard.setValue(self.pid, forKey: UserData.DEFAULT_USER_PID)
        UserDefaults.standard.setValue(self.shareCode, forKey: UserData.DEFAULT_USER_SHARE_CODE)
    }

}
