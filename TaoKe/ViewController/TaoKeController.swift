//
//  TaoKeController.swift
//  TaoKe
//
//  Created by jason tsang on 11/2/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import UIColor_Hex_Swift

class TaoKeController: RAMAnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIViewController {
    func initNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor("#f5f5f5")
        self.navigationController?.navigationBar.tintColor = UIColor("#424242")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor("#424242")]
        
        let statusBar = UIView(frame: CGRect(x: 0, y: -view.bounds.size.height, width: view.bounds.size.width, height: view.bounds.size.height))
        statusBar.backgroundColor = UIColor("#ffa726")
        self.navigationController?.navigationBar.addSubview(statusBar)
    }
}
