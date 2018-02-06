
import RxSwift

protocol TaoKeProtocol {
    
    func tao(api: String) -> Observable<TaoKeData?>
    
    func tao(api: String, auth: String) -> Observable<TaoKeData?>
    
    func tao(api: String, auth: String, data: NSMutableDictionary) -> Observable<TaoKeData?>
    
    func tao(api: String, auth: String, data: NSMutableDictionary, images: UIImage...) -> Observable<TaoKeData?>
    
    static func getInstance() -> TaoKeProtocol
    
}
