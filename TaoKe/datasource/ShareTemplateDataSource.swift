
import RxSwift

class ShareTemplateDataSource: RxDataSource<ShareImage> {
    
    var selected: Int = -1
    var cache: [ShareImage]?
    
    init(viewController: UIViewController) {
        super.init(viewController)
    }
    
    override func refresh() -> Observable<[ShareImage]> {
        if cache != nil {
            for index in 0 ..< (cache?.count)! {
                let shareImage = cache?[index]
                shareImage?.selected = index == self.selected
            }
            return Observable.just(cache!)
        }
        
        return TaoKeApi.getShareTemplates((UserData.get()?.getShareType())!).map({ (urls) -> [ShareImage] in
            var items: [ShareImage] = []
            if let shareUrls = urls {
                for index in 0 ..< shareUrls.count {
                    let shareImage = ShareImage()
                    shareImage.thumb = shareUrls[index]
                    shareImage.selected = index == self.selected
                    items.append(shareImage)
                }
            }
            self.cache = items
            return items
        })
    }
}
