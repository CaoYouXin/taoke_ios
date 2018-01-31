
import RxSwift

class ProductDataSource: SortableDataSource {
    
    private var homeBtn: HomeBtn?
    
    init(viewController: UIViewController, homeBtn: HomeBtn?) {
        self.homeBtn = homeBtn
        super.init(viewController)
    }
    
    override func refreshApi() -> Observable<[CouponItem]> {
        return TaoKeApi.getProductList((homeBtn?.ext)!).map({ (favItemsView) -> [CouponItem] in
            self.ordered = favItemsView.orders
            return favItemsView.items!
        })
    }
    
}
