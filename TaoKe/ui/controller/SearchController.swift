
import FontAwesomeKit

class SearchController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
