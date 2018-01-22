
class EnrollSubmit {
    public static let DEFAULT_REALNAME = "DEFAULT_REALNAME"
    public static let DEFAULT_QQID = "DEFAULT_QQID"
    public static let DEFAULT_WECHATID = "DEFAULT_WECHATID"
    public static let DEFAULT_ANNOUNCEMENT = "DEFAULT_ANNOUNCEMENT"
    
    public var realName: String?
    public var qqId: String?
    public var weChatId: String?
    public var announcement: String?
    
    init () {
    }
    
    init (_ r: String?, _ q: String?, _ w: String?, _ am: String?) {
        self.realName = r
        self.qqId = q
        self.weChatId = w
        self.announcement = am
    }
    
    public func toBody() -> NSMutableDictionary {
        let result = NSMutableDictionary()
        if let v = self.realName {
            result["realName"] = v
        }
        if let v = self.qqId {
            result["qqId"] = v
        }
        if let v = self.weChatId {
            result["weChatId"] = v
        }
        if let v = self.announcement {
            result["announcement"] = v
        }
        return result
    }
    
    public func cache() {
        UserDefaults.standard.setValue(self.realName, forKey: EnrollSubmit.DEFAULT_REALNAME)
        UserDefaults.standard.setValue(self.qqId, forKey: EnrollSubmit.DEFAULT_QQID)
        UserDefaults.standard.setValue(self.weChatId, forKey: EnrollSubmit.DEFAULT_WECHATID)
        UserDefaults.standard.setValue(self.announcement, forKey: EnrollSubmit.DEFAULT_ANNOUNCEMENT)
    }
    
    public static func restore() -> EnrollSubmit? {
        if let realName = UserDefaults.standard.string(forKey: EnrollSubmit.DEFAULT_REALNAME) {
            let result = EnrollSubmit()
            result.realName = realName
            result.qqId = UserDefaults.standard.string(forKey: EnrollSubmit.DEFAULT_QQID)
            result.weChatId = UserDefaults.standard.string(forKey: EnrollSubmit.DEFAULT_WECHATID)
            result.announcement = UserDefaults.standard.string(forKey: EnrollSubmit.DEFAULT_ANNOUNCEMENT)
            return result
        }
        return nil
    }
    
    public static func clear() {
        UserDefaults.standard.removeObject(forKey: EnrollSubmit.DEFAULT_REALNAME)
        UserDefaults.standard.removeObject(forKey: EnrollSubmit.DEFAULT_QQID)
        UserDefaults.standard.removeObject(forKey: EnrollSubmit.DEFAULT_WECHATID)
        UserDefaults.standard.removeObject(forKey: EnrollSubmit.DEFAULT_ANNOUNCEMENT)
    }
    
}
