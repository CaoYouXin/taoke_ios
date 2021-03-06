
import CleanroomLogger
import RxSwift
import RxCocoa
import FontAwesomeKit

class SignInController: UIViewController {
    
    @IBOutlet weak var backIcon: UIImageView!
    @IBOutlet weak var backText: UILabel!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordVisible: UIImageView!
    @IBOutlet weak var signIn: UILabel!
    @IBOutlet weak var signUp: UILabel!
    @IBOutlet weak var resetPassword: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backIcon.image = FAKFontAwesome.chevronLeftIcon(withSize: 20).image(with: CGSize(width: 20, height: 20))
        let eyeIcon = FAKMaterialIcons.eyeIcon(withSize: 20)
        eyeIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#bdbdbd"))
        passwordVisible.image = eyeIcon?.image(with: CGSize(width: 20, height: 20))
        
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = UIColor("#FFB74D").cgColor
        signIn.layer.cornerRadius = 18
        
        let binder = { (observable: Observable<String>) -> Disposable in
            return observable.subscribe(onNext: { _ in
                let phone = self.phoneNo.text!
                let password = self.password.text!
                if RegExpUtil.isPhoneNo(phoneNo: phone) && password.utf16.count >= 6 {
                    self.signIn.isUserInteractionEnabled = true
                    self.signIn.textColor = UIColor("#ffa726")
                } else {
                    self.signIn.isUserInteractionEnabled = false
                    self.signIn.textColor = UIColor("#ffb74d")
                }
            }, onError: { (error) in
                Log.error?.message(error.localizedDescription)
            })
        }
        
        phoneNo.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged().bind(to: binder).disposed(by: disposeBag)
        password.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged().bind(to: binder).disposed(by: disposeBag)
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        passwordVisible.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        backIcon.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        backText.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        signIn.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        signUp.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        resetPassword.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case backIcon, backText:
            navigationController?.popViewController(animated: true)
            break
        case passwordVisible:
            password.isSecureTextEntry = !password.isSecureTextEntry
            let eyeIcon = FAKMaterialIcons.eyeIcon(withSize: 20)
            eyeIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: password.isSecureTextEntry ? UIColor("#bdbdbd") : UIColor.black)
            passwordVisible.image = eyeIcon?.image(with: CGSize(width: 20, height: 20))
        case signIn:
            self.view.endEditing(true)
            view.makeToastActivity(.center)
            TaoKeApi.signIn(phone: phoneNo.text!, password: password.text!)
                .rxSchedulerHelper()
                .handleApiError(self, { (error) in
                    self.view.hideToastActivity()
                })
                .subscribe(onNext: { _ in
                    self.view.hideToastActivity()
                    self.navigationController?.performSegue(withIdentifier: "segue_splash_to_taoke", sender: nil)
                }).disposed(by: disposeBag)
        case signUp:
            performSegue(withIdentifier: "segue_sign_in_to_sign_up", sender: nil)
        case resetPassword:
            performSegue(withIdentifier: "segue_sign_in_to_reset_password", sender: nil)
        default:
            self.view.endEditing(true)
            break
        }
    }
}
