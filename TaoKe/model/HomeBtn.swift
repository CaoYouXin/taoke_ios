import RealmSwift

class HomeBtn: Object {
    
    @objc dynamic public var imgUrl: String?
    @objc dynamic public var name: String?
    @objc dynamic public var openType: Int = -1
    @objc dynamic public var ext: String?
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    func copy() -> HomeBtn {
        let homeBtn = HomeBtn()
        homeBtn.imgUrl = imgUrl
        homeBtn.name = name
        homeBtn.openType = openType
        homeBtn.ext = ext
        return homeBtn
    }
    
    public static func from(_ results: Results<HomeBtn>) -> [HomeBtn] {
        var data: [HomeBtn] = []
        for result in results {
            data.append(result.copy())
        }
        return data
    }
}
