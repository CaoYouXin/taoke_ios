//
//  SplashController.swift
//  TaoKe
//
//  Created by jason tsang on 11/6/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import UIKit
import RxSwift

class SplashController: UIViewController {
    @IBOutlet weak var splashImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIView.animate(withDuration: 3, animations: { () -> Void in
            self.splashImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (finished) -> Void in
            self.performSegue(withIdentifier: "segue_splash_to_taoke", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
