
import UIKit

class OrderCell: UICollectionViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var shop: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var teammate: UILabel!
    @IBOutlet weak var teammateWidth: NSLayoutConstraint!
    
    @IBOutlet weak var payedAmount: UILabel!
    @IBOutlet weak var estimateEffect: UILabel!
    @IBOutlet weak var estimateIncome: UILabel!
    @IBOutlet weak var createTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        status.layer.cornerRadius = 12.5
        teammate.layer.backgroundColor = UIColor.brown.withAlphaComponent(0.3).cgColor
        teammate.layer.cornerRadius = 12.5
    }
    
}
