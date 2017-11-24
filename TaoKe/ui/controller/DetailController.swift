//
//  DetailActivity.swift
//  TaoKe
//
//  Created by jason tsang on 11/13/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import CleanroomLogger
import FontAwesomeKit
import ImageSlideshow
import RxSwift
import RxSegue

class DetailController: UIViewController {
    var couponItem: CouponItem?
    
    @IBOutlet weak var picSliders: ImageSlideshow!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailViewIcon: UIImageView!
    @IBOutlet weak var couponPriceWrapper: UIView!
    @IBOutlet weak var detailPriceAfterIcon: UILabel!
    @IBOutlet weak var detailPriceAfter: UILabel!
    @IBOutlet weak var noCouponWrapper: UIView!
    @IBOutlet weak var detailPriceBefore: UILabel!
    @IBOutlet weak var detailSales: UILabel!
    @IBOutlet weak var couponWrapper: UIView!
    @IBOutlet weak var couponPriceBefore: UILabel!
    @IBOutlet weak var saleVolume: UILabel!
    @IBOutlet weak var couponInfoWrapper: UIView!
    @IBOutlet weak var detailCouponIcon: UIImageView!
    @IBOutlet weak var detailCoupon: UILabel!
    @IBOutlet weak var earnWrapper: UIView!
    @IBOutlet weak var detailCommissionIcon: UIImageView!
    @IBOutlet weak var detailCommission: UILabel!
    @IBOutlet weak var buyerWrapper: UIView!
    @IBOutlet weak var detailShare: UILabel!
    @IBOutlet weak var detailApp: UILabel!
    @IBOutlet weak var agentShare: UILabel!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "宝贝推广信息"
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        detailShare.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        detailApp.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        agentShare.addGestureRecognizer(tapGestureRecognizer)
        
        initView()
    }
    
    private func initView() {
        self.picSliders.slideshowInterval = 3
        self.picSliders.contentScaleMode = .scaleAspectFill
        var imageSources: [KingfisherSource] = [KingfisherSource(urlString: (couponItem?.pictUrl)!)!];
        for url in (couponItem?.smallImages)! {
            imageSources.append(KingfisherSource(urlString: url)!)
        }
        self.picSliders.setImageInputs(imageSources)
        
        self.detailTitle.text = couponItem?.title
        
        let newspaperOIcon = FAKFontAwesome.newspaperOIcon(withSize: 20)
        newspaperOIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#424242"))
        self.detailViewIcon.image = newspaperOIcon?.image(with: CGSize(width: 20, height: 20))
        
        if let constraint = (self.couponInfoWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.couponItem?.couponInfo == nil ? 0 : 20
        }
        
        if let constraint = (self.couponWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.couponItem?.couponInfo == nil ? 0 : 30
        }
        
        if let constraint = (self.noCouponWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.couponItem?.couponInfo == nil ? 30 : 0
        }
        
        if let constraint = (self.couponPriceWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = self.couponItem?.couponInfo == nil ? 0 : 30
        }
        
        if let constraint = (self.earnWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = (UserData.get()?.isBuyer())! ? 0 : 20
        }
        
        if couponItem?.couponInfo == nil {
            
            self.couponPriceBefore.text = "现价 ¥ \(couponItem?.zkFinalPrice! ?? "")"
            self.saleVolume.text = "已售\(couponItem?.volume! ?? 0)件"
        } else {
            
            self.detailPriceAfterIcon.layer.cornerRadius = 2;
            self.detailPriceAfterIcon.layer.masksToBounds = true;
            self.detailPriceAfterIcon.layer.borderWidth = 1
            self.detailPriceAfterIcon.layer.borderColor = UIColor("#f57c00").cgColor
            self.detailPriceAfter.text = couponItem?.couponPrice
            
            var text = "现价 ¥ \(couponItem?.zkFinalPrice! ?? "")"
            let location = text.index(of: "¥")!.encodedOffset + 2
            let range = NSRange(location: location, length: text.utf16.count - location)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSUnderlineStyle.patternSolid.rawValue | NSUnderlineStyle.styleSingle.rawValue, range: range)
            self.detailPriceBefore.attributedText = attributedText
            self.detailSales.text = "已售\(couponItem?.volume! ?? 0)件"
            
            let ticketStarIcon = FAKMaterialIcons.ticketStarIcon(withSize: 16)
            ticketStarIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
            self.detailCouponIcon.image = ticketStarIcon?.image(with: CGSize(width: 16, height: 16))
            self.detailCoupon.text = "优惠券 \(couponItem?.couponInfo! ?? "")"
        }
        
        if !(UserData.get()?.isBuyer())! {
            let moneyIcon = FAKFontAwesome.moneyIcon(withSize: 16)
            moneyIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#757575"))
            self.detailCommissionIcon.image = moneyIcon?.image(with: CGSize(width: 16, height: 16))
            self.detailCommission.text = "分享预计赚 ¥ \(couponItem?.earnPrice! ?? "")"
        }
        
        if let constraint = (self.agentShare.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = (UserData.get()?.isBuyer())! ? 0 : 48
        }
        
        if let constraint = (self.buyerWrapper.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = (UserData.get()?.isBuyer())! ? 48 : 0
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        switch sender.view! {
        case detailShare, agentShare:
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

