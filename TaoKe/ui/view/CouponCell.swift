//
//  CouponCell.swift
//  TaoKe
//
//  Created by jason tsang on 11/9/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import FontAwesomeKit

class CouponCell: UICollectionViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    
    @IBOutlet weak var couponTitle: UILabel!
    
    @IBOutlet weak var couponPriceBefore: UILabel!
    
    @IBOutlet weak var couponPriceAfter: UILabel!
    
    @IBOutlet weak var couponProgress: UIProgressView!
    
    @IBOutlet weak var couponValue: UILabel!
    
    @IBOutlet weak var couponSpreadIcon: UIImageView!
    @IBOutlet weak var couponEarn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let shareSquareOIcon = FAKFontAwesome.shareSquareOIcon(withSize: 20)
        shareSquareOIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#e65100"))
        couponSpreadIcon.image = shareSquareOIcon?.image(with: CGSize(width: 20, height: 20))
        couponSpreadIcon.layer.cornerRadius = couponSpreadIcon.frame.size.width / 2;
        couponSpreadIcon.layer.masksToBounds = true;
        couponSpreadIcon.layer.borderWidth = 1
        couponSpreadIcon.layer.borderColor = UIColor("#f57c00").cgColor
        
        couponProgress.layer.cornerRadius = 7
        couponProgress.layer.masksToBounds = true;
    }
}
