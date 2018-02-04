
import RxSwift

class HelpDocDataSource: RxDataSource<HelpDoc> {
    
    override func refresh() -> Observable<[HelpDoc]> {
        return TaoKeApi.getHelpDocs()
    }
    
    override func loadMore() -> Observable<[HelpDoc]> {
        return Observable.empty()
    }
    
    override func loadCache() -> Observable<[HelpDoc]> {
        return Observable.empty()
    }
}
