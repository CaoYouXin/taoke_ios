import CleanroomLogger
import RxSwift

class SplashController: UIViewController {
    
    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var anonymous: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor("#FFB74D").cgColor
        signUp.layer.cornerRadius = 6
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = UIColor("#FFB74D").cgColor
        signIn.layer.cornerRadius = 6
        anonymous.layer.borderWidth = 1
        anonymous.layer.borderColor = UIColor("#999999").cgColor
        anonymous.layer.cornerRadius = 18
        anonymous.layer.masksToBounds = true
        
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            self.splashImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
        
        if UserData.restore() {
            Observable<Int>.timer(RxTimeInterval(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: {
                    _ in
                    self.navigationController?.performSegue(withIdentifier: "segue_splash_to_taoke", sender: nil)
                }, onError: {
                    error in
                    Log.error?.message(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else {
            UIView.animate(withDuration: 1.5, animations: { () -> Void in
                self.signUp.alpha = 1
                self.signIn.alpha = 1
                self.anonymous.alpha = 1
            })
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        anonymous.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        view.makeToastActivity(.center)
        TaoKeApi.anonymous()
            .rxSchedulerHelper()
            .handleApiError(self, { (error) in
                self.view.hideToastActivity()
                Log.error?.message(error.localizedDescription)
                if let error = error as? ApiError {
                    if let message = error.message {
                        self.view.makeToast(message)
                        return
                    }
                }
                self.view.makeToast("登录失败，网络连接异常...")
            })
            .subscribe(onNext: { _ in
                self.view.hideToastActivity()
                self.navigationController?.performSegue(withIdentifier: "segue_splash_to_taoke", sender: nil)
            }).disposed(by: disposeBag)
    }
    
}
