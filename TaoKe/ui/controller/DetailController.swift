//
//  DetailActivity.swift
//  TaoKe
//
//  Created by jason tsang on 11/13/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import CleanroomLogger
import FontAwesomeKit
import RxSwift
import RxSegue

class DetailController: UIViewController {
    var couponItem: CouponItem?
    
    @IBOutlet weak var detailThumb: UIImageView!
    
    @IBOutlet weak var detailTitle: UILabel!
    
    @IBOutlet weak var detailViewIcon: UIImageView!
    
    @IBOutlet weak var detailPriceAfterIcon: UILabel!
    
    @IBOutlet weak var detailPriceAfter: UILabel!
    
    @IBOutlet weak var detailPriceBefore: UILabel!
    
    @IBOutlet weak var detailSales: UILabel!

    @IBOutlet weak var detailCouponIcon: UIImageView!
    
    @IBOutlet weak var detailCoupon: UILabel!
    
    @IBOutlet weak var detailCommissionIcon: UIImageView!

    @IBOutlet weak var detailCommission: UILabel!
    
    @IBOutlet weak var detailShare: UILabel!
    
    @IBOutlet weak var detailApp: UILabel!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "宝贝推广信息"
        
        TaoKeApi.getCouponDetail(couponItem!).rxSchedulerHelper().subscribe(onNext: { (couponItemDetail) in
            self.detailThumb.kf.setImage(with: URL(string: couponItemDetail.thumb!))
            self.detailTitle.text = couponItemDetail.title
            
            let newspaperOIcon = FAKFontAwesome.newspaperOIcon(withSize: 20)
            newspaperOIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#424242"))
            self.detailViewIcon.image = newspaperOIcon?.image(with: CGSize(width: 20, height: 20))
            
            self.detailPriceAfterIcon.layer.cornerRadius = 2;
            self.detailPriceAfterIcon.layer.masksToBounds = true;
            self.detailPriceAfterIcon.layer.borderWidth = 1
            self.detailPriceAfterIcon.layer.borderColor = UIColor("#f57c00").cgColor
            
            self.detailPriceAfter.text = couponItemDetail.priceAfter
            
            var text = "现价 ¥ \(couponItemDetail.priceBefore!)"
            var location = text.index(of: "¥")!.encodedOffset + 2
            var range = NSRange(location: location, length: text.utf16.count - location)
            var attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSUnderlineStyle.patternSolid.rawValue | NSUnderlineStyle.styleSingle.rawValue, range: range)
            self.detailPriceBefore.attributedText = attributedText
            
            self.detailSales.text = "已售\(couponItemDetail.sales!)件"
            
            let ticketStarIcon = FAKMaterialIcons.ticketStarIcon(withSize: 16)
            ticketStarIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
            self.detailCouponIcon.image = ticketStarIcon?.image(with: CGSize(width: 16, height: 16))
            
            text = "优惠券 \(couponItemDetail.coupon!)元（满\(couponItemDetail.couponRequirement!)使用）"
            attributedText = NSMutableAttributedString(string: text)
            location = text.index(of: " ")!.encodedOffset
            range = NSRange(location: location, length: text.index(of: "元")!.encodedOffset - location)
            attributedText.addAttribute(.foregroundColor, value: UIColor("#ef6c00"), range: range)
            location = text.index(of: "（")!.encodedOffset
            range = NSRange(location: location, length: text.utf16.count - location)
            attributedText.addAttribute(.foregroundColor, value: UIColor("#9e9e9e"), range: range)
            self.detailCoupon.attributedText = attributedText
            
            let moneyIcon = FAKFontAwesome.moneyIcon(withSize: 16)
            moneyIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
            self.detailCommissionIcon.image = moneyIcon?.image(with: CGSize(width: 16, height: 16))
            
            text = "通用佣金 \(couponItemDetail.commissionPercent!)（预计 ¥\(couponItemDetail.commission!)）"
            attributedText = NSMutableAttributedString(string: text)
            location = text.index(of: "（")!.encodedOffset
            range = NSRange(location: location, length: text.utf16.count - location)
            attributedText.addAttribute(.foregroundColor, value: UIColor("#9e9e9e"), range: range)
            self.detailCommission.attributedText = attributedText
        }, onError: { (error) in
            Log.error?.message(error.localizedDescription)
        })
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        detailShare.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        detailApp.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case detailShare:
            let shareController = UIStoryboard(name: "Share", bundle: nil).instantiateViewController(withIdentifier: "ShareController") as! ShareController
            shareController.couponItem = couponItem
            self.navigationController?.pushViewController(shareController, animated: true)
        default:
            break
        }
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

