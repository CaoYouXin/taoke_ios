//
//  ProductCell.swift
//  TaoKe
//
//  Created by jason tsang on 11/15/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var thumb: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var isNewWrapper: UIView!
    
    @IBOutlet weak var isNew: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var sales: UILabel!
}
