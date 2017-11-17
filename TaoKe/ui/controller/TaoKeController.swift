//
//  TaoKeController.swift
//  TaoKe
//
//  Created by jason tsang on 11/2/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import RAMAnimatedTabBarController
import UIColor_Hex_Swift
import FontAwesomeKit

class TaoKeController: RAMAnimatedTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.searchIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(search))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func search() {
        let searchController = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchController") as! SearchController
        self.navigationController?.pushViewController(searchController, animated: true)
    }
}

extension UIViewController {
    func initNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor("#f5f5f5")
        navigationController?.navigationBar.tintColor = UIColor("#424242")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor("#424242")]
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowOpacity = 0.2;
        
        let statusBar = UIView(frame: CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.size.height, width: view.bounds.size.width, height: UIApplication.shared.statusBarFrame.size.height))
        statusBar.backgroundColor = UIColor("#ffa726")
        navigationController?.navigationBar.addSubview(statusBar)
    }
}
