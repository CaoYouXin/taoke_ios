
import RxSwift

class BrandDataSource: RxDataSource<HomeBtn> {
    override func refresh() -> Observable<[HomeBtn]> {
        return TaoKeApi.getBrandList()
    }
}
