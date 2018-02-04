
import RxSwift

class HelpDataSource: RxDataSource<HelpView> {
    
    override func refresh() -> Observable<[HelpView]> {
        return TaoKeApi.getHelpList()
    }
    
    override func loadMore() -> Observable<[HelpView]> {
        return Observable.empty()
    }
    
    override func loadCache() -> Observable<[HelpView]> {
        return Observable.empty()
    }
}
