
import UIKit
import FontAwesomeKit
import RxSwift

class CustomerServiceController: UIViewController {

    @IBOutlet weak var qq: UILabel!
    @IBOutlet weak var qqCmd: UILabel!
    @IBOutlet weak var wechat: UILabel!
    @IBOutlet weak var wechatCmd: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "客服中心"
        
        qqCmd.layer.borderWidth = 1
        qqCmd.layer.borderColor = UIColor("#FFD500").cgColor
        qqCmd.layer.cornerRadius = 15
        wechatCmd.layer.borderWidth = 1
        wechatCmd.layer.borderColor = UIColor("#FFD500").cgColor
        wechatCmd.layer.cornerRadius = 15
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.qqCmd.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.wechatCmd.addGestureRecognizer(tapGestureRecognizer)
        
        TaoKeApi.getCustomerService().rxSchedulerHelper().handleApiError(self)
            .subscribe(onNext: { (view) in
                self.wechat.text = view.weChat
                self.qq.text = view.mqq
            }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case qqCmd:
            if (qq.text?.elementsEqual(""))! {
                break
            }
            
            let pasteboard = UIPasteboard.general
            pasteboard.string = qq.text
            
            let url = URL(string: "mqq://")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:])
            }
            break
        case wechatCmd:
            if (wechat.text?.elementsEqual(""))! {
                break
            }
            
            let pasteboard = UIPasteboard.general
            pasteboard.string = wechat.text
            
            let url = URL(string: "weixin://")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:])
            }
            break
        default:break
        }
    }
    
}
