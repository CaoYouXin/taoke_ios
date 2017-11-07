//
//  DiscoverController.swift
//  TaoKe
//
//  Created by jason tsang on 11/6/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import UIKit
import ImageSlideshow
import TabLayoutView

class DiscoverController: UIViewController {
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    @IBOutlet weak var couponTab: TabLayoutView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initSlider()
        self.initCouponTab()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initSlider() {
        slideshow.slideshowInterval = 3
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.draggingEnabled = false
        
        updateSlider()
    }
    
    private func updateSlider() {
        slideshow.setImageInputs([
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!),
            ImageSource(image: UIImage(named: "splash")!)
//            KingfisherSource(urlString: "http://7xi8d6.com1.z0.glb.clouddn.com/20171025112955_lmesMu_katyteiko_25_10_2017_11_29_43_270.jpeg")!
            ])
    }
    
    private func initCouponTab() {
        couponTab.indicatorColor = UIColor("#ef6c00")
        couponTab.fontSelectedColor = UIColor("#ef6c00")
        TaoKeApi.getCouponTab().rxSchedulerHelper().subscribe(onNext: { tabs in
            var items: [String] = []
            for tab in tabs {
                items.append(tab.title == nil ? "" : tab.title!)
            }
            self.couponTab.items = items
        }, onError: { error in

        }, onCompleted: {
            
        })
    }
}
