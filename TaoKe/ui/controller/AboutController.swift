
import UIKit
import FontAwesomeKit

class AboutController: UIViewController {
    
    @IBOutlet weak var aboutText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "关于"
        
        self.aboutText.text = "\t\t觅券儿app-电商导购行业专业app，汇集淘宝、京东、唯品会等各大电商平台优惠券，专业选品团队，每日精选好货，严格把控品质！网购买手必备，省钱、赚钱，就上觅券儿！\n专业选品团队，严控品质；\n各大网购平台优惠信息，每日更新；\n通信功能，信息实时触达；\n登录简单，操作便捷。\n\n觅券儿客户端致力于服务好广大用户，欢迎提出各种建议和反馈。\n\n反馈邮箱：2033992811@qq.com。公众号二维码："
        self.aboutText.preferredMaxLayoutWidth = self.view.frame.width - 60
        self.aboutText.textAlignment = .left;
        self.aboutText.numberOfLines = 0;
        self.aboutText.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
