//
//  AccountViewController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/18.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import UIKit
import FontAwesomeKit

class AccountController: UIViewController {

    @IBOutlet weak var rightArrow1: UIImageView!
    @IBOutlet weak var rightArrow2: UIImageView!
    @IBOutlet weak var rightArrow3: UIImageView!
    @IBOutlet weak var rightArrow4: UIImageView!
    @IBOutlet weak var rightArrow5: UIImageView!
    @IBOutlet weak var rightArrow6: UIImageView!
    
    @IBOutlet weak var newerGuideImage: UIImageView!
    @IBOutlet weak var shareToImage: UIImageView!
    @IBOutlet weak var enrollImage: UIImageView!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var helpReportImage: UIImageView!
    @IBOutlet weak var aboutImage: UIImageView!
    
    @IBOutlet weak var newGuideBtn: UIButton!
    @IBOutlet weak var shareToBtn: UIButton!
    @IBOutlet weak var enrollBtn: UIButton!
    @IBOutlet weak var teamBtn: UIButton!
    @IBOutlet weak var helpReportBtn: UIButton!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightArrowIcon = FAKFontAwesome.chevronRightIcon(withSize: 16)
        rightArrowIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
        self.rightArrow1.image = rightArrowIcon?.image(with: CGSize(width: 16, height: 16))
        self.rightArrow2.image = rightArrowIcon?.image(with: CGSize(width: 16, height: 16))
        self.rightArrow3.image = rightArrowIcon?.image(with: CGSize(width: 16, height: 16))
        self.rightArrow4.image = rightArrowIcon?.image(with: CGSize(width: 16, height: 16))
        self.rightArrow5.image = rightArrowIcon?.image(with: CGSize(width: 16, height: 16))
        self.rightArrow6.image = rightArrowIcon?.image(with: CGSize(width: 16, height: 16))
        
        let newGuideIcon = FAKFontAwesome.questionCircleIcon(withSize: 20)
        newGuideIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#FFE24F"))
        self.newerGuideImage.image = newGuideIcon?.image(with: CGSize(width: 20, height: 20))
        
        let shareToIcon = FAKFontAwesome.shareSquareOIcon(withSize: 20)
        shareToIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#9AD2FF"))
        self.shareToImage.image = shareToIcon?.image(with: CGSize(width: 20, height: 20))
        
        let enrollIcon = FAKFontAwesome.codeForkIcon(withSize: 20)
        enrollIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#666666"))
        self.enrollImage.image = enrollIcon?.image(with: CGSize(width: 20, height: 20))
        
        let teamIcon = FAKFontAwesome.usersIcon(withSize: 20)
        teamIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#CC9900"))
        self.teamImage.image = teamIcon?.image(with: CGSize(width: 20, height: 20))
        
        let helpReportIcon = FAKFontAwesome.commentingIcon(withSize: 20)
        helpReportIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#66CDAA"))
        self.helpReportImage.image = helpReportIcon?.image(with: CGSize(width: 20, height: 20))
        
        let aboutIcon = FAKFontAwesome.infoCircleIcon(withSize: 20)
        aboutIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#00BFFF"))
        self.aboutImage.image = aboutIcon?.image(with: CGSize(width: 20, height: 20))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        switch sender {
        case newGuideBtn:
            let newerGuideController = UIStoryboard(name: "NewerGuide", bundle: nil).instantiateViewController(withIdentifier: "NewerGuideController") as! NewerGuideController
            self.navigationController?.pushViewController(newerGuideController, animated: true)
            break
        case shareToBtn:
            let alert = UIAlertController(title: "", message: "点击分享给好友", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: { (action) in
            }))
            self.present(alert, animated: true)
            break
        case enrollBtn:
            
            break
        case teamBtn:
            
            break
        case helpReportBtn:
            
            break
        case aboutBtn:
            let aboutController = UIStoryboard(name: "About", bundle: nil).instantiateViewController(withIdentifier: "AboutController") as! AboutController
            self.navigationController?.pushViewController(aboutController, animated: true)
            break
        case exitBtn:
            
            break
        default: break
        }
    }
    
}
