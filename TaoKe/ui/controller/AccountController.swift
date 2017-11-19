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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
