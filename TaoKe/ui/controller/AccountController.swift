
import UIKit
import RxSwift
import FontAwesomeKit

class AccountController: UIViewController {

    @IBOutlet weak var scrollWrapper: UIScrollView!
    
    @IBOutlet weak var avatar: UIImageView!
    
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
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountType: UILabel!
    @IBOutlet weak var viewWrapper: UIView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarMask = UIBezierPath(ovalIn: avatar.bounds)
        let avatarMaskLayer = CAShapeLayer()
        avatarMaskLayer.path = avatarMask.cgPath
        avatar.layer.mask = avatarMaskLayer
        
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
        
//        self.shareToImage.isHidden = true
//        self.shareToBtn.isHidden = true
//        self.rightArrow2.isHidden = true
//        if let constraint = (self.shareToBtn.constraints.filter({$0.firstAttribute == .height}).first) {
//            constraint.constant = 0
//        }
        
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
        
        self.accountName.text = UserData.get()?.name
        self.accountType.text = UserData.get()?.getUserType()
        
        if let constraint = (self.viewWrapper.constraints.filter({$0.firstAttribute == .top && ($0.firstItem?.isEqual(self.enrollBtn))!}).first) {
            constraint.constant = (UserData.get()?.candidate)! || !(UserData.get()?.isBuyer())! ? 20 : 0
        }
        if let constraint = (self.enrollBtn.constraints.filter({$0.firstAttribute == .height}).first) {
            constraint.constant = (UserData.get()?.candidate)! ? 50 : 0
        }
        if let constraint = (self.teamBtn.constraints.filter({$0.firstAttribute == .height}).first) {
            constraint.constant = !(UserData.get()?.isBuyer())! ? 50 : 0
        }
        
        if !(UserData.get()?.candidate)! {
            self.enrollBtn.isHidden = true
            self.enrollImage.isHidden = true
            self.rightArrow3.isHidden = true
        }
        
        if (UserData.get()?.isBuyer())! {
            self.teamBtn.isHidden = true
            self.teamImage.isHidden = true
            self.rightArrow4.isHidden = true
        }
        
        if #available(iOS 11, *) {
            // ignore
        } else {
            scrollWrapper.contentInset = UIEdgeInsets(top: 0 - scrollWrapper.frame.minY, left: 0, bottom: 0, right: 0)
        }
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
            let shareAppController = UIStoryboard(name: "ShareApp", bundle: nil).instantiateViewController(withIdentifier: "ShareAppController") as! ShareAppController
            self.navigationController?.pushViewController(shareAppController, animated: true)
            break
        case enrollBtn:
            if !(UserData.get()?.isBuyer())! {
                let alert = UIAlertController(title: "", message: "您已经是合伙人了", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .cancel, handler: { (action) in
                }))
                self.present(alert, animated: true)
                return
            }
            
            let enrollController = UIStoryboard(name: "Enroll", bundle: nil).instantiateViewController(withIdentifier: "EnrollController") as! EnrollController
            self.navigationController?.pushViewController(enrollController, animated: true)
            break
        case teamBtn:
            let teamController = UIStoryboard(name: "Team", bundle: nil).instantiateViewController(withIdentifier: "TeamController") as! TeamController
            self.navigationController?.pushViewController(teamController, animated: true)
            break
        case helpReportBtn:
            let helpController = UIStoryboard(name: "HelpReport", bundle: nil).instantiateViewController(withIdentifier: "HelpController") as! HelpController
            self.navigationController?.pushViewController(helpController, animated: true)
            break
        case aboutBtn:
            let aboutController = UIStoryboard(name: "About", bundle: nil).instantiateViewController(withIdentifier: "AboutController") as! AboutController
            self.navigationController?.pushViewController(aboutController, animated: true)
            break
        case exitBtn:
            let alert = UIAlertController(title: "", message: "确定注销吗？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "注销", style: .default, handler: { (action) in
                UserData.clear()
                self.navigationController?.performSegue(withIdentifier: "segue_taoke_to_splash", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            }))
            self.present(alert, animated: true)
            break
        default: break
        }
    }
    
}
