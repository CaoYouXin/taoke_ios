
import RxSwift

enum SortBy: Int {
    case sales
    case commissionUp
    case commissionDown
    case couponUp
    case couponDown
    case priceUp
    case priceDown
}

class SortableDataSource: RxDataSource<CouponItem> {
    
    var sortBy: SortBy?
    var cache: [CouponItem]?
    
    func refreshApi() -> Observable<[CouponItem]> {
        return Observable.empty()
    }
    
    override func refresh() -> Observable<[CouponItem]> {
        var observable: Observable<[CouponItem]>
        if cache == nil {
            observable = refreshApi()
        } else {
            observable = Observable.just(cache!)
        }
        
        return observable.map({ (data) -> [CouponItem] in
            self.cache = data
            if self.sortBy == nil {
                return data
            }
            
            switch self.sortBy! {
            case .sales:
                return data.sorted(by: { (item1, item2) -> Bool in
                    return item1.volume! > item2.volume!
                })
            case .commissionUp:
                return data.sorted(by: { (item1, item2) -> Bool in
                    item1.numEarn! < item2.numEarn!
                })
            case .commissionDown:
                return data.sorted(by: { (item1, item2) -> Bool in
                    item1.numEarn! > item2.numEarn!
                })
            case .couponUp:
                return data.sorted(by: { (item1, item2) -> Bool in
                    item1.numCoupon! < item2.numCoupon!
                })
            case .couponDown:
                return data.sorted(by: { (item1, item2) -> Bool in
                    item1.numCoupon! > item2.numCoupon!
                })
            case .priceUp:
                return data.sorted(by: { (item1, item2) -> Bool in
                    item1.numPrice! < item2.numPrice!
                })
            case .priceDown:
                return data.sorted(by: { (item1, item2) -> Bool in
                    item1.numPrice! > item2.numPrice!
                })
            }
        })
    }
    
}
