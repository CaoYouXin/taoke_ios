
class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var priceAfter: UILabel!
    @IBOutlet weak var priceBefore: UILabel!
    @IBOutlet weak var couponSales: UILabel!
    @IBOutlet weak var couponHeight: NSLayoutConstraint!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var noCouponHeight: NSLayoutConstraint!
    
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var earn: UILabel!
    @IBOutlet weak var blockHeight: NSLayoutConstraint!

}
