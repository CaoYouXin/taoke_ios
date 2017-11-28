import CleanroomLogger
import RxSwift
import RxCocoa
import FontAwesomeKit

class ResetPasswordController: UIViewController {
    
    @IBOutlet weak var backIcon: UIImageView!
    
    @IBOutlet weak var backText: UILabel!
    
    @IBOutlet weak var phoneNo: UITextField!
    
    @IBOutlet weak var verificationCode: UITextField!
    
    @IBOutlet weak var verificationCodeSend: UILabel!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordVisible: UIImageView!
    
    @IBOutlet weak var resetPassword: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                backIcon.image = FAKFontAwesome.chevronLeftIcon(withSize: 20).image(with: CGSize(width: 20, height: 20))
        
        let eyeIcon = FAKMaterialIcons.eyeIcon(withSize: 20)
        eyeIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#bdbdbd"))
        passwordVisible.image = eyeIcon?.image(with: CGSize(width: 20, height: 20))
        
        resetPassword.layer.borderWidth = 1
        resetPassword.layer.borderColor = UIColor("#FFB74D").cgColor
        resetPassword.layer.cornerRadius = 18
        
        let binder = { (observable: Observable<String>) -> Disposable in
            return observable.subscribe(onNext: { _ in
                let phone = self.phoneNo.text!
                let code = self.verificationCode.text!
                let password = self.password.text!
                if RegExpUtil.isPhoneNo(phoneNo: phone) {
                    self.verificationCodeSend.isUserInteractionEnabled = true
                    self.verificationCodeSend.textColor = .black
                } else {
                    self.verificationCodeSend.isUserInteractionEnabled = false
                    self.verificationCodeSend.textColor = UIColor("#bdbdbd")
                }
                if RegExpUtil.isPhoneNo(phoneNo: phone) && code.utf16.count == 6 && password.utf16.count >= 6 {
                    self.resetPassword.isUserInteractionEnabled = true
                    self.resetPassword.textColor = UIColor("#ffa726")
                } else {
                    self.resetPassword.isUserInteractionEnabled = false
                    self.resetPassword.textColor = UIColor("#ffb74d")
                }
            }, onError: { (error) in
                Log.error?.message(error.localizedDescription)
            })
        }
        
        phoneNo.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged().bind(to: binder).disposed(by: disposeBag)
        verificationCode.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged().bind(to: binder).disposed(by: disposeBag)
        password.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged().bind(to: binder).disposed(by: disposeBag)
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        backIcon.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        backText.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        verificationCodeSend.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        passwordVisible.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        resetPassword.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case backIcon, backText:
            navigationController?.popViewController(animated: true)
        case verificationCodeSend:
            if verificationCodeSend.text?.compare("获取验证码").rawValue == 0 {
                verificationCodeSend.textColor = UIColor("#bdbdbd")
                verificationCodeSend.text = "60"
                Observable<Int>.interval(RxTimeInterval(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                    .take(60)
                    .rxSchedulerHelper()
                    .subscribe(onNext: { time in
                        if time == 59 {
                            self.verificationCodeSend.textColor = .black
                            self.verificationCodeSend.text = "获取验证码"
                        } else {
                            self.verificationCodeSend.text = "\(59 - time)"
                        }
                    }, onError: { (error) in
                        Log.error?.message(error.localizedDescription)
                    }).disposed(by: disposeBag)
                
                TaoKeApi.verification(phone: phoneNo.text!)
                    .rxSchedulerHelper()
                    .subscribe().disposed(by: disposeBag)
            }
        case passwordVisible:
            password.isSecureTextEntry = !password.isSecureTextEntry
            let eyeIcon = FAKMaterialIcons.eyeIcon(withSize: 20)
            eyeIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: password.isSecureTextEntry ? UIColor("#bdbdbd") : UIColor.black)
            passwordVisible.image = eyeIcon?.image(with: CGSize(width: 20, height: 20))
        case resetPassword:
            view.makeToastActivity(.center)
            TaoKeApi.resetPassword(phone: phoneNo.text!, verificationCode: verificationCode.text!, password: password.text!)
                .rxSchedulerHelper()
                .subscribe(onNext: { _ in
                    self.view.hideToastActivity()
                    if UserDefaults.standard.bool(forKey: IntroController.INTRO_READ) {
                        self.navigationController?.performSegue(withIdentifier: "segue_splash_to_taoke", sender: nil)
                    } else {
                        self.navigationController?.performSegue(withIdentifier: "segue_splash_to_intro", sender: nil)
                    }
                }, onError: { (error) in
                    self.view.hideToastActivity()
                    Log.error?.message(error.localizedDescription)
                    if let error = error as? ApiError {
                        if let message = error.message {
                            self.view.makeToast(message)
                            return
                        }
                    }
                    self.view.makeToast("重置密码失败，网络连接异常...")
                }).disposed(by: disposeBag)
        default:
            break
        }
    }
}
