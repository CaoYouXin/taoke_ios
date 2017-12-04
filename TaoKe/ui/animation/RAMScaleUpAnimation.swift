
import RAMAnimatedTabBarController

class RAMScaleUpAnimation : RAMItemAnimation {
        override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
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
    
        override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
                if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = defaultTextColor
        }
        textLabel.textColor = defaultTextColor
        icon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        textLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
        override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
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
