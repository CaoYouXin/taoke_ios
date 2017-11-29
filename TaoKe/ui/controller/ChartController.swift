//
//  ChartController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/29.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import UIKit
import FontAwesomeKit
import MJRefresh

class ChartController: UIViewController {

    @IBOutlet weak var scrollWrapper: UIScrollView!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var canDraw: UILabel!
    @IBOutlet weak var withDraw: UILabel!
    @IBOutlet weak var thisEstimate: UILabel!
    @IBOutlet weak var thatEstimate: UILabel!
    @IBOutlet weak var orderDetails: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightArrowIcon = FAKFontAwesome.chevronRightIcon(withSize: 16)
        rightArrowIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
        rightArrow.image = rightArrowIcon?.image(with: CGSize(width: 16, height: 16))
        let orderImageIcon = FAKFontAwesome.addressBookIcon(withSize: 20)
        orderImageIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#00BFFF"))
        orderImage.image = orderImageIcon?.image(with: CGSize(width: 20, height: 20))
    
        withDraw.layer.borderWidth = 1
        withDraw.layer.borderColor = UIColor("#FFD500").cgColor
        withDraw.layer.cornerRadius = 15
        
        initScroll()
        initCanDraw()
        initThisEstimate()
        initThatEstimate()
    }

    private func initScroll() {
        scrollWrapper.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            
            self.initCanDraw()
            self.initThisEstimate()
            self.initThatEstimate()
            
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.scrollWrapper.mj_header.endRefreshing()
            }
        })
    }
    
    private func initThatEstimate() {
        let _ = TaoKeApi.getThisEstimate().rxSchedulerHelper().handleUnAuth(viewController: self)
            .subscribe(onNext: { (data) in
                let text = "本月结算效果预估\n¥ \(data)"
                let attribuites = NSMutableAttributedString(string: text)
                let location = (text.index(of: "¥")?.encodedOffset)! + 2
                let length = (text.index(of: ".")?.encodedOffset)! - location
                let range = NSRange(location: location, length: length)
                attribuites.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 28), range: range)
                self.thisEstimate.attributedText = attribuites
                self.thisEstimate.numberOfLines = 0
            })
    }
    
    private func initThisEstimate() {
        let _ = TaoKeApi.getThatEstimate().rxSchedulerHelper().handleUnAuth(viewController: self)
            .subscribe(onNext: { (data) in
                let text = "上月结算效果预估\n¥ \(data)"
                let attribuites = NSMutableAttributedString(string: text)
                let location = (text.index(of: "¥")?.encodedOffset)! + 2
                let length = (text.index(of: ".")?.encodedOffset)! - location
                let range = NSRange(location: location, length: length)
                attribuites.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 28), range: range)
                self.thatEstimate.attributedText = attribuites
                self.thatEstimate.numberOfLines = 0
            })
    }
    
    private func initCanDraw() {
        let _ = TaoKeApi.getCanDraw().rxSchedulerHelper().handleUnAuth(viewController: self)
            .subscribe(onNext: { (data) in
                let text = "¥ \(data)"
                let attribuites = NSMutableAttributedString(string: text)
                let location = (text.index(of: "¥")?.encodedOffset)! + 2
                let length = (text.index(of: ".")?.encodedOffset)! - location
                let range = NSRange(location: location, length: length)
                attribuites.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 28), range: range)
                self.canDraw.attributedText = attribuites
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
