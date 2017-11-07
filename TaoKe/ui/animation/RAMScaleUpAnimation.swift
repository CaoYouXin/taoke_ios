//
//  RAMScaleUpAnimation.swift
//  TaoKe
//
//  Created by jason tsang on 11/6/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

/// The RAMBounceAnimation class provides bounce animation.
class RAMScaleUpAnimation : RAMItemAnimation {
    // method call when Tab Bar Item is selected
    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        // add animation
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
        textLabel.textColor = textSelectedColor
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            icon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            textLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
    }
    
    // method call when Tab Bar Item is deselected
    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        // add animation
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = defaultTextColor
        }
        textLabel.textColor = defaultTextColor
        icon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        textLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    // method call when TabBarController did load
    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        // set selected state
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
        textLabel.textColor = textSelectedColor
        icon.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        textLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
}
