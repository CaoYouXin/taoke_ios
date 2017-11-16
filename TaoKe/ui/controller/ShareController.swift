//
//  ShareController.swift
//  TaoKe
//
//  Created by jason tsang on 11/16/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import CleanroomLogger
import FontAwesomeKit

class ShareController: UIViewController {
    
    var couponItem: CouponItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize.init(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
