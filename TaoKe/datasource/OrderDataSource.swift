
import RxSwift

enum OrderFetchType: Int {
    case ALL = 1
    case ALL_EFFECTIVE = 2
    case INEFFECTIVE = 6
    case EFFECTIVE_PAYED = 3
    case EFFECTIVE_CONSIGNED = 4
    case EFFECTIVE_SETTLED = 5
}

class OrderDataSource: RxDataSource<OrderView> {
    
    var type: OrderFetchType?
    var pageNo: Int?
    
    override func refresh() -> Observable<[OrderView]> {
        if type == nil {
            return Observable.empty()
        }
        
        pageNo = 1
        return TaoKeApi.getOrderList(type!, pageNo!)
    }
    
    override func loadMore() -> Observable<[OrderView]> {
        if type == nil || pageNo == nil {
            return Observable.empty()
        }
        
        pageNo = pageNo! + 1
        return TaoKeApi.getOrderList(type!, pageNo!)
    }
    
    override func loadCache() -> Observable<[OrderView]> {
        return Observable.empty()
    }
    
}
