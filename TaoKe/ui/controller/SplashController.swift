//
//  SplashController.swift
//  TaoKe
//
//  Created by jason tsang on 11/6/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import CleanroomLogger
import RxSwift

class SplashController: UIViewController {
    @IBOutlet weak var splashImage: UIImageView!
    
    @IBOutlet weak var appName: UIImageView!
    
    @IBOutlet weak var signUp: UIButton!
    
    @IBOutlet weak var signIn: UIButton!
    
    private let disposeBag = DisposeBag()
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor("#FFB74D").cgColor
        signUp.layer.cornerRadius = 6
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = UIColor("#FFB74D").cgColor
        signIn.layer.cornerRadius = 6
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.splashImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.appName.alpha = 1
        })
        
        if UserData.restore() {
            Observable<Int>.timer(RxTimeInterval(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: {
                    _ in
                    if UserDefaults.standard.bool(forKey: IntroController.INTRO_READ) {
                        self.navigationController?.performSegue(withIdentifier: "segue_splash_to_taoke", sender: nil)
                    } else {
                        self.navigationController?.performSegue(withIdentifier: "segue_splash_to_intro", sender: nil)
                    }
                }, onError: {
                    error in
                    Log.error?.message(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else {
            UIView.animate(withDuration: 1.5, animations: { () -> Void in
                self.signUp.alpha = 1
                self.signIn.alpha = 1
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
