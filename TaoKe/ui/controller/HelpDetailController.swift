
import UIKit
import RxSwift
import FontAwesomeKit

class HelpDetailController: UIViewController {

    @IBOutlet weak var theWebView: UIWebView!
    
    var helpView: HelpDoc?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "帮助详情"
        
        theWebView.delegate = self
        
        theWebView.loadRequest(URLRequest(url: URL(string: TaoKeService.HOST + "blog/"
            + (helpView?.path?.replacingOccurrences(of: "/", with: "&@&"))!
            + "//" + TaoKeApi.CDN.replacingOccurrences(of: "/", with: "&@&"))!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension HelpDetailController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
}
