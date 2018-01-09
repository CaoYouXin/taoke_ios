
import RxSwift
//import RealmSwift
import CleanroomLogger

class BrandDataSource: RxDataSource<AdZoneItem> {
//    private var config: Realm.Configuration
    
//    override init(_ viewController: UIViewController? = nil) {
//        config = Realm.Configuration()
//        config.fileURL!.appendingPathComponent("BrandList")
//        config.schemaVersion = UInt64(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
//        super.init(viewController)
//    }
    
    override func loadCache() -> Observable<[AdZoneItem]> {
        return Observable.empty()
//        return Observable.just(config).map({ config -> [HomeBtn] in
//            let realm = try! Realm(configuration: config)
//            let results = realm.objects(HomeBtn.self)
//            var cache: [HomeBtn] = HomeBtn.from(results)
//            return cache
//        })
    }
    
    override func refresh() -> Observable<[AdZoneItem]> {
        return TaoKeApi.getAdZoneItems()
//        return TaoKeApi.getBrandList().map({ (homeBtns) -> [HomeBtn] in
//            Realm.asyncOpen(configuration: self.config) { realm, error in
//                if let realm = realm {
//                    try! realm.write {
//                        realm.delete(realm.objects(HomeBtn.self))
//                        realm.add(homeBtns, update: true)
//                    }
//                } else if let error = error {
//                    Log.error?.message(error.localizedDescription)
//                }
//            }
//            return homeBtns
//        })
    }
}
