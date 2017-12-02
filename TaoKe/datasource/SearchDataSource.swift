
import RxSwift

class SearchDataSource: SortableDataSource {
    
    var keyword: String?
    var isJu: Bool?
    
    override func refreshApi() -> Observable<[CouponItem]> {
        if isJu == nil || keyword == nil {
            return Observable.empty()
        }
        
        if isJu! {
            return TaoKeApi.juSearchItems(keyword!)
        } else {
            return TaoKeApi.searchCouponList(keyword!)
        }
    }
    
}
