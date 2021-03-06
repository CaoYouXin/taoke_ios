
import RxSwift
import EAIntroView

class IntroController: UIViewController {
    
    public static let INTRO_READ = "intro_read_2"
    
    @IBOutlet weak var introView: EAIntroView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIntroView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initIntroView() {
        if UserDefaults.standard.bool(forKey: IntroController.INTRO_READ) {
            self.navigationController?.performSegue(withIdentifier: "segue_to_splash", sender: nil)
        } else {
            
            introView.pages = []
            var introPage = EAIntroPage()
            introPage.bgImage = #imageLiteral(resourceName: "intro_1")
            introView.pages.append(introPage)
            introPage = EAIntroPage()
            introPage.bgImage = #imageLiteral(resourceName: "intro_2")
            introView.pages.append(introPage)
            introPage = EAIntroPage()
            introPage.bgImage = #imageLiteral(resourceName: "intro_3")
            introView.pages.append(introPage)
            introPage = EAIntroPage()
            introPage.bgImage = #imageLiteral(resourceName: "intro_4")
            introView.pages.append(introPage)
            
            introView.delegate = self
        }
    }
}

extension IntroController: EAIntroDelegate {
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        UserDefaults.standard.setValue(true, forKey: IntroController.INTRO_READ)
        self.navigationController?.performSegue(withIdentifier: "segue_to_splash", sender: nil)
    }
}
