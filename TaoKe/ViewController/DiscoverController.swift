//
//  DiscoverController.swift
//  TaoKe
//
//  Created by jason tsang on 11/6/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import UIKit
import ImageSlideshow

class DiscoverController: UIViewController {
    
    var slideshow: ImageSlideshow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        self.initSlider()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initSlider() {
        slideshow = ImageSlideshow(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width * 9 / 16))
        slideshow?.slideshowInterval = 3
        slideshow?.contentScaleMode = .scaleAspectFill
        slideshow?.draggingEnabled = false
        view.addSubview(slideshow!)
        updateSlider()
    }
    
    private func updateSlider() {
        slideshow!.setImageInputs([
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!)
//            KingfisherSource(urlString: "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg")!
            ])
    }
}
