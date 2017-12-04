
import UIKit
import RxSwift
import FontAwesomeKit

class HelpDetailController: UIViewController {

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
        answer.text = helpView?.answer
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }

}
