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
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "新手引导"
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        let thumbs = [
            "https://ws1.sinaimg.cn/large/610dc034ly1fitcjyruajj20u011h412.jpg",
            "http://7xi8d6.com1.z0.glb.clouddn.com/20171107100244_0fbENB_yyannwong_7_11_2017_10_2_5_982.jpeg"
        ];

        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 0
        
        for thumb in thumbs {
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            img.kf.setImage(with: URL(string: thumb), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if let tmp = image {
                    let ratio = tmp.size.width / tmp.size.height
                    img.frame = CGRect(x: 0, y: 0, width: img.frame.width, height: img.frame.width / ratio)
                }
            })
            stackView.addArrangedSubview(img)
        }
        
        containerView.addSubview(stackView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
}
