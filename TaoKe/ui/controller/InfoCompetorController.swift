
import CleanroomLogger
import UIKit
import FontAwesomeKit
import RxSwift

class InfoCompetorController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var alipay: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var vCode: UITextField!
    @IBOutlet weak var genCode: UILabel!
    @IBOutlet weak var submit: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "用户信息补全"

        submit.layer.borderWidth = 1
        submit.layer.borderColor = UIColor("#FFD500").cgColor
        submit.layer.cornerRadius = 13
        
        name.text = UserData.get()?.realName
        phone.text = UserData.get()?.phone
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.submit.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.genCode.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
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
        case submit:
            self.view.endEditing(true)
            if (alipay.text?.elementsEqual(""))! {
                let alert = UIAlertController(title: "", message: "必须填写支付宝号！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "去填写", style: .cancel, handler: { (action) in
                    self.alipay.becomeFirstResponder()
                }))
                self.present(alert, animated: true)
                return
            }
            
            if (vCode.text?.elementsEqual(""))! {
                let alert = UIAlertController(title: "", message: "必须填写验证码！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "去填写", style: .cancel, handler: { (action) in
                    self.vCode.becomeFirstResponder()
                }))
                self.present(alert, animated: true)
                return
            }
            
            TaoKeApi.toCompeteInfo(code: vCode.text!, phone: phone.text!, alipay: alipay.text!)
                .rxSchedulerHelper().handleApiError(self, { (error) in
                    Log.error?.message(error.localizedDescription)
                    if let error = error as? ApiError {
                        if let message = error.message {
                            self.view.makeToast(message)
                            return
                        }
                    }
                    self.view.makeToast("登录失败，网络连接异常...")
                }).subscribe(onNext: { _ in
                    self.navigationController?.popViewController(animated: true)
                }).disposed(by: disposeBag)
            break
        case genCode:
            if genCode.text?.compare("获取验证码").rawValue == 0
                || genCode.text?.compare("重新获取").rawValue == 0 {
                genCode.textColor = UIColor("#bdbdbd")
                genCode.text = "60"
                Observable<Int>.interval(RxTimeInterval(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                    .take(60)
                    .rxSchedulerHelper()
                    .subscribe(onNext: { time in
                        if time == 59 {
                            self.genCode.textColor = .black
                            self.genCode.text = "重新获取"
                        } else {
                            self.genCode.text = "\(59 - time)"
                        }
                    }).disposed(by: disposeBag)
                
                TaoKeApi.verification(phone: self.phone.text!)
                    .rxSchedulerHelper()
                    .handleApiError(self, nil)
                    .subscribe().disposed(by: disposeBag)
            }
            break
        default:
            self.view.endEditing(true)
            break
        }
    }
    
}
