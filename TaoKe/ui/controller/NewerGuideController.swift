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
    @IBOutlet weak var newerGuideList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "新手引导"
        newerGuideList.spacing = 0
        
        for _ in 1 ..< 20 {
            let imageView = UIImageView()
            newerGuideList.addArrangedSubview(imageView)
            newerGuideList.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0))
            
            imageView.kf.setImage(with: URL(string: "http://sjbz.fd.zol-img.com.cn/t_s800x1280c/g5/M00/07/04/ChMkJ1jlsOKIUYUYAAQhvA87IyIAAbZHwKhfVgABCHU427.jpg"), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                    if let img = image {
                        let ratio = img.size.height / img.size.width
                        let height = self.view.frame.width * ratio
                        
                        if let constraint = (self.newerGuideList.constraints.filter{$0.firstAttribute == .height && $0.firstItem!.isEqual(imageView)}.first) {
                            constraint.constant = height
                        }
                        
                        if let constraint = (self.newerGuideList.constraints.filter{$0.firstAttribute == .height && $0.firstItem!.isEqual(self.newerGuideList)}.first) {
                            constraint.constant += (height + self.newerGuideList.spacing)
                        }
                    }
                })
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
