//
//  NewerGuideController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/20.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import UIKit
import FontAwesomeKit

class NewerGuideController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var newerGuideList: UICollectionView!
    @IBOutlet weak var newerGuideListFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "新手引导"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
}
