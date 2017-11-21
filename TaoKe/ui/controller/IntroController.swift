//
//  IntroController.swift
//  TaoKe
//
//  Created by jason tsang on 11/20/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import EAIntroView

class IntroController: UIViewController {
    public static let INTRO_READ = "intro_read"
    
    @IBOutlet weak var introView: EAIntroView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initIntroView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initIntroView() {
        introView.pages = []
        var introPage = EAIntroPage()
        introPage.bgImage = #imageLiteral(resourceName: "splash")
        introView.pages.append(introPage)
        introPage = EAIntroPage()
        introPage.bgImage = #imageLiteral(resourceName: "splash")
        introView.pages.append(introPage)
        introPage = EAIntroPage()
        introPage.bgImage = #imageLiteral(resourceName: "splash")
        introView.pages.append(introPage)
        introPage = EAIntroPage()
        introPage.bgImage = #imageLiteral(resourceName: "splash")
        introView.pages.append(introPage)
        introPage = EAIntroPage()
        introPage.bgImage = #imageLiteral(resourceName: "splash")
        introView.pages.append(introPage)
        
        introView.delegate = self
    }
}

extension IntroController: EAIntroDelegate {
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        UserDefaults.standard.setValue(true, forKey: IntroController.INTRO_READ)
        self.navigationController?.performSegue(withIdentifier: "segue_to_taoke", sender: nil)
    }
}
