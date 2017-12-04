
import UIKit
import RxSwift
import FontAwesomeKit

class H5DetailController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var itemId: String?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        webView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "商品详情"
        
        if let numiid = self.itemId {
            let page = AlibcTradePageFactory.itemDetailPage(String(numiid))
            let showParam = AlibcTradeShowParams()
            showParam.openType = .H5
            let taokeParams = AlibcTradeTaokeParams()
            taokeParams.pid = UserData.get()?.pid
            AlibcTradeSDK.sharedInstance().tradeService().show(self, webView: webView, page: page, showParams: showParam, taoKeParams: taokeParams, trackParam: nil, tradeProcessSuccessCallback: { (alibcTradeResult) in
                self.view.makeToast("alibc open taobao successfully")
            }, tradeProcessFailedCallback: { (error) in
                self.view.makeToast("alibc open taobao fail \(error.debugDescription)")
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension H5DetailController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let path = Bundle.main.path(forResource: "hack", ofType: "css")
        var contents: String
        do {
            contents = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch {
            return
        }
        let data = contents.data(using: String.Encoding.utf8)?.base64EncodedString()
        
        webView.stringByEvaluatingJavaScript(from: """
            (function() {
                var parent = document.getElementsByTagName('body').item(0);
                var hacked = document.getElementById('hackCss');
                if (hacked) { parent.removeChild(hacked); }
                var style = document.createElement('style');
                style.id = 'hackCss';
                style.type = 'text/css';
                style.innerHTML = window.atob('\(data ?? "")');
                parent.appendChild(style);
            })()
        """)
        
//        alert(style.innerHTML);
    }
}
