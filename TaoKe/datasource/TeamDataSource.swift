
import RxSwift

class TeamDataSource: RxDataSource<TeamDataView> {
    override func refresh() -> Observable<[TeamDataView]> {
        return TaoKeApi.getTeamCommition()
    }
    
    override func loadMore() -> Observable<[TeamDataView]> {
        return Observable.empty()
    }
    
    override func loadCache() -> Observable<[TeamDataView]> {
        return Observable.empty()
    }
}
