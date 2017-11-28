
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
