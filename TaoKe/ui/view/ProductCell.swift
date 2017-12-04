
class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var noCouponWrapper: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var couponWrapper: UIStackView!
    @IBOutlet weak var priceBefore: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var priceAfter: UILabel!
    @IBOutlet weak var couponInfo: UILabel!
    @IBOutlet weak var earnWrapper: UIView!
    @IBOutlet weak var earn: UILabel!
    
}
