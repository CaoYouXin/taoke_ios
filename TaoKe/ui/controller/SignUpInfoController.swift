//
//  SignUpInfoController.swift
//  TaoKe
//
//  Created by jason tsang on 11/20/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import CleanroomLogger
import RxSwift
import RxCocoa
import FontAwesomeKit

class SignUpInfoController: UIViewController {
    @IBOutlet weak var backIcon: UIImageView!
    
    @IBOutlet weak var backText: UILabel!
    
    @IBOutlet weak var verificationCode: UITextField!
    
    @IBOutlet weak var verificationCodeResend: UILabel!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordVisible: UIImageView!
    
    @IBOutlet weak var nickName: UITextField!
    
    @IBOutlet weak var signUp: UILabel!
    
    var phoneNo: String?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backIcon.image = FAKFontAwesome.chevronLeftIcon(withSize: 20).image(with: CGSize(width: 20, height: 20))
        let eyeIcon = FAKMaterialIcons.eyeIcon(withSize: 20)
        eyeIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#bdbdbd"))
        passwordVisible.image = eyeIcon?.image(with: CGSize(width: 20, height: 20))
        
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor("#FFB74D").cgColor
        signUp.layer.cornerRadius = 18
        
        let binder = { (observable: Observable<String>) -> Disposable in
            return observable.subscribe(onNext: { _ in
                let code = self.verificationCode.text!
                let password = self.verificationCode.text!
                if code.utf16.count == 6 && password.utf16.count >= 6 {
                    self.signUp.isUserInteractionEnabled = true
                    self.signUp.textColor = UIColor("#ffa726")
                } else {
                    self.signUp.isUserInteractionEnabled = false
                    self.signUp.textColor = UIColor("#ffb74d")
                }
            }, onError: { (error) in
                Log.error?.message(error.localizedDescription)
            })
        }
        
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
        verificationCodeResend.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        passwordVisible.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        signUp.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case backIcon, backText:
            navigationController?.popViewController(animated: true)
        case verificationCodeResend:
            if verificationCodeResend.text?.compare("重新获取").rawValue == 0 {
                verificationCodeResend.textColor = UIColor("#bdbdbd")
                verificationCodeResend.text = "60"
                Observable<Int>.interval(RxTimeInterval(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                    .take(60)
                    .rxSchedulerHelper()
                    .subscribe(onNext: { time in
                        if time == 59 {
                            self.verificationCodeResend.textColor = .black
                            self.verificationCodeResend.text = "重新获取"
                        } else {
                            self.verificationCodeResend.text = "\(59 - time)"
                        }
                    }, onError: { (error) in
                        Log.error?.message(error.localizedDescription)
                    }).disposed(by: disposeBag)
                
                TaoKeApi.verification(phone: phoneNo!)
                    .rxSchedulerHelper()
                    .subscribe().disposed(by: disposeBag)
            }
        case passwordVisible:
            password.isSecureTextEntry = !password.isSecureTextEntry
            let eyeIcon = FAKMaterialIcons.eyeIcon(withSize: 20)
            eyeIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: password.isSecureTextEntry ? UIColor("#bdbdbd") : UIColor.black)
            passwordVisible.image = eyeIcon?.image(with: CGSize(width: 20, height: 20))
        case signUp:
            view.makeToastActivity(.center)
            TaoKeApi.signUp(phone: phoneNo!, verificationCode: verificationCode.text!, password: password.text!)
                .rxSchedulerHelper()
                .subscribe(onNext: { _ in
                    self.view.hideToastActivity()
                    if UserDefaults.standard.bool(forKey: IntroController.INTRO_READ) {
                        self.navigationController?.navigationController?.performSegue(withIdentifier: "segue_to_taoke", sender: nil)
                    } else {
                        self.navigationController?.navigationController?.performSegue(withIdentifier: "segue_to_intro", sender: nil)
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
                    self.view.makeToast("注册失败，网络连接异常...")
                }).disposed(by: disposeBag)
        default:
            break
        }
    }
}