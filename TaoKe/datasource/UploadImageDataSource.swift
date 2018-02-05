
import RxSwift

class UploadImageDataSource: RxDataSource<UploadImageItem> {
    
    private var data: [UploadImageItem]
    
    override init(_ viewController: UIViewController?) {
        let handle = UploadImageItem()
        handle.isHandle = true
        handle.uploaded = true
        self.data = [handle]
        super.init(viewController)
    }
    
    public func addImage(uri: String) {
        let item = UploadImageItem()
        item.isHandle = false
        item.uploaded = false
        item.uri = uri
        self.data.insert(item, at: 0)
    }
    
    public func setImageCode(uri: String, codeSource: String) {
        for datum in self.data {
            if datum.uri == uri {
                datum.code = String.init(format: "![](%@)", codeSource)
                return
            }
        }
    }
    
    override func refresh() -> Observable<[UploadImageItem]> {
        return Observable.just(data)
    }
    
    override func loadMore() -> Observable<[UploadImageItem]> {
        return Observable.empty()
    }
    
    override func loadCache() -> Observable<[UploadImageItem]> {
        return Observable.empty()
    }
}
