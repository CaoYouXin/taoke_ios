//
//  AboutController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/20.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import UIKit
import FontAwesomeKit

class AboutController: UIViewController {

    @IBOutlet weak var aboutText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "关于"
        
        self.aboutText.text = "\t淘客客户端是由『X公司』自主开发，为淘宝客推出的一款移动客户端软件。淘客用户可以随时随地通过手机进行导购推广…，以及接收…消息。\n\n\t淘客客户端致力于服务好广大用户，欢迎提出各种建议和反馈。\n\n反馈邮箱: xxx@xxx.com"
        self.aboutText.preferredMaxLayoutWidth = self.view.frame.width - 60
        self.aboutText.textAlignment = .left;
        self.aboutText.numberOfLines = 0;
        self.aboutText.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }

}
