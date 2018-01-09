
import UIKit
import RxSwift
import FontAwesomeKit

class HelpDetailController: UIViewController {

    @IBOutlet weak var scrollWrapper: UIScrollView!
    @IBOutlet weak var qWrapper: UIView!
    @IBOutlet weak var aWrapper: UIView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer: UILabel!
    
    var helpView: HelpView?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "帮助详情"
        
        question.text = helpView?.title
        let qSize = question.sizeThatFits(CGSize(width: self.view.frame.size.width - 32, height: 0))
        qWrapper.frame = CGRect(x: qWrapper.frame.midX, y: qWrapper.frame.midY, width: qWrapper.frame.width, height: qSize.height + CGFloat(20))
        
        answer.text = helpView?.answer
        let aSize = answer.sizeThatFits(CGSize(width: self.view.frame.size.width - 32, height: 0))
        aWrapper.frame.size.height = aSize.height + CGFloat(20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }

}
