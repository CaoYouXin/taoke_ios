//
//  SignUpController.swift
//  TaoKe
//
//  Created by jason tsang on 11/20/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import CleanroomLogger
import RxSwift
import RxCocoa
import FontAwesomeKit
import Toast_Swift

class SignUpController: UIViewController {
    
    @IBOutlet weak var backIcon: UIImageView!
    
    @IBOutlet weak var backText: UILabel!
    
    @IBOutlet weak var phoneNo: UITextField!
    
    @IBOutlet weak var signUp: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backIcon.image = FAKFontAwesome.chevronLeftIcon(withSize: 20).image(with: CGSize(width: 20, height: 20))
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor("#FFB74D").cgColor
        signUp.layer.cornerRadius = 18
        
        phoneNo.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { (phone) in
                if RegExpUtil.isPhoneNo(phoneNo: phone) {
                    self.signUp.isUserInteractionEnabled = true
                    self.signUp.textColor = UIColor("#ffa726")
                } else {
                    self.signUp.isUserInteractionEnabled = false
                    self.signUp.textColor = UIColor("#ffb74d")
                }
            }, onError: { (error) in
                Log.error?.message(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        backIcon.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        backText.addGestureRecognizer(tapGestureRecognizer)
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
            break
        case signUp:
            view.makeToastActivity(.center)
            if let phone = phoneNo.text {
                TaoKeApi.verification(phone: phone)
                    .rxSchedulerHelper()
                    .subscribe(onNext: { _ in
                        self.view.hideToastActivity()
                        let signUpInfoController = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewController(withIdentifier: "SignUpInfoController") as! SignUpInfoController
                        signUpInfoController.phoneNo = phone
                        self.navigationController?.pushViewController(signUpInfoController, animated: true)
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
            }
            break
        default:
            break
        }
    }
}
