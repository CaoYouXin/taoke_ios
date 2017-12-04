
import FontAwesomeKit

class SortHelper {
    
    var mainBar: [String:UILabel] = [:]
    var directionBar: [String:[UIImageView]] = [:]
    var sortType: [String:[SortBy]] = [:]
    var flip: [String:Bool] = [:]
    
    private var sort: SortBy?
    private let grey400 = UIColor("#bdbdbd")
    private let grey900 = UIColor("#212121")
    private let chevronUpIconGrey400 = FAKFontAwesome.chevronUpIcon(withSize: 8)
    private let chevronDownIconGrey400 = FAKFontAwesome.chevronDownIcon(withSize: 8)
    private let chevronUpIconGrey900 = FAKFontAwesome.chevronUpIcon(withSize: 8)
    private let chevronDownIconGrey900 = FAKFontAwesome.chevronDownIcon(withSize: 8)
    
    init () {
        chevronUpIconGrey400?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey400)
        chevronDownIconGrey400?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey400)
        chevronUpIconGrey900?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey900)
        chevronDownIconGrey900?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey900)
    }
    
    public func setup(id: String, main: UILabel, directions: [UIImageView]?, types: [SortBy], flag: Bool) {
        mainBar[id] = main
        if let dBar = directions {
            directionBar[id] = dBar
        }
        sortType[id] = types
        flip[id] = flag
    }
    
    public func calcSortBy(clickOn: String) -> SortBy {
        for label in mainBar.values {
            label.textColor = grey400
        }
        for images in directionBar.values {
            images[0].image = chevronUpIconGrey400?.image(with: CGSize(width: 8, height: 8))
            images[1].image = chevronDownIconGrey400?.image(with: CGSize(width: 8, height: 8))
        }
        
        mainBar[clickOn]?.textColor = grey900
        let candidates = sortType[clickOn]
        let idx1 = flip[clickOn]! ? 1 : 0
        let idx2 = flip[clickOn]! ? 0 : 1
        
        if candidates![idx1] == sort {
            sort = candidates![idx2]
            if let directions = directionBar[clickOn] {
                directions[idx2].image = flip[clickOn]! ? chevronUpIconGrey900?.image(with: CGSize(width: 8, height: 8))
                    : chevronDownIconGrey900?.image(with: CGSize(width: 8, height: 8))
            }
        } else {
            sort = candidates![idx1]
            if let directions = directionBar[clickOn] {
                directions[idx1].image = flip[clickOn]! ? chevronDownIconGrey900?.image(with: CGSize(width: 8, height: 8))
                    : chevronUpIconGrey900?.image(with: CGSize(width: 8, height: 8))
            }
        }
        
        return sort!
    }
    
}
