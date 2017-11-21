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
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var newerGuideList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "新手引导"
        
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        newerGuideList.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 1 ..< 20 {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "splash"))
            newerGuideList.addArrangedSubview(imageView)
            newerGuideList.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100))
            if let constraint = (newerGuideList.constraints.filter{$0.firstAttribute == .height}.first) {
                constraint.constant += (100 + newerGuideList.spacing)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
