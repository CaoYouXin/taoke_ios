
import RxSwift

class BrandDataSource: RxDataSource<HomeBtn> {
    var i = 0
    
    override func refresh() -> Observable<[HomeBtn]> {
        var observables: [Observable<[HomeBtn]>] = []
        for _ in 0...i {
            observables.append(TaoKeApi.getBrandList())
        }
        i += 1
        if i == 6 {
            i == 0
            return TaoKeApi.getBrandList()
        }
        return Observable.zip(observables).map({ (homeBtns) -> [HomeBtn] in
            var btns: [HomeBtn] = []
            for homeBtn in homeBtns {
                btns.append(contentsOf: homeBtn)
            }
            return btns
        })
    }
}
