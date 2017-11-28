
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
