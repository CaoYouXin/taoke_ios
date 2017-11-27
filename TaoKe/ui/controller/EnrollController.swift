//
//  EnrollController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/27.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import UIKit
import FontAwesomeKit

class EnrollController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var enrollSpec: UILabel!
    @IBOutlet weak var submitBtn: UILabel!
    @IBOutlet weak var announcement: UITextView!
    @IBOutlet weak var wechat: UITextField!
    @IBOutlet weak var qq: UITextField!
    @IBOutlet weak var alipay: UITextField!
    @IBOutlet weak var realName: UITextField!
    
    private let announcementHint = "申请理由"
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.elementsEqual(announcementHint) {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count < 1 {
            textView.text = announcementHint
            textView.textColor = UIColor.gray
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "申请成为合伙人"
        
        self.enrollSpec.text = "\t\t申请后，我们的工作人员会及时审核。当审核通过后，您将需要重新登录，以更新客户端状态。\n\n一旦成为代理，您将拥有自己的团队，通过将APP分享给好友注册以及直接分享商品给好友带来收入。\n\n同时，由于相关规定，成为代理后将不能享受普通购买者的优惠，不能在APP内跳转手淘。"
        self.enrollSpec.textAlignment = .left;
        self.enrollSpec.numberOfLines = 0;
        self.enrollSpec.sizeToFit()
        
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.borderColor = UIColor("#FFD500").cgColor
        submitBtn.layer.cornerRadius = 18
        
        announcement.layer.borderWidth = 1
        announcement.layer.borderColor = UIColor("#EED533").cgColor
        announcement.layer.cornerRadius = 3
        announcement.text = announcementHint
        announcement.textColor = UIColor.gray
        announcement.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        submitBtn.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
