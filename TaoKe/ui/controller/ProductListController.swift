//
//  ProductListController.swift
//  TaoKe
//
//  Created by jason tsang on 11/15/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//

import CleanroomLogger
import FontAwesomeKit

class ProductListController: UIViewController {
    
    @IBOutlet weak var sortMultiple: UILabel!
    
    @IBOutlet weak var sortSales: UILabel!
    
    @IBOutlet weak var sortCommission: UILabel!
    
    @IBOutlet weak var sortPriceWrapper: UIView!
    
    @IBOutlet weak var sortPrice: UILabel!
    
    @IBOutlet weak var sortPriceUp: UIImageView!
    
    @IBOutlet weak var sortPriceDown: UIImageView!
    
    @IBOutlet weak var productList: UICollectionView!
    
    @IBOutlet weak var productListFlowLayout: UICollectionViewFlowLayout!
    
    var brandItem: BrandItem?
    
    var sort: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize.init(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = brandItem!.title!
        
        initSortBar()
        initProductList()
    }
    
    private func initSortBar() {
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortMultiple.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortSales.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortCommission.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSortBar))
        sortPriceWrapper.addGestureRecognizer(tapGestureRecognizer)
        
        let chevronUpIcon = FAKFontAwesome.chevronUpIcon(withSize: 8)
        chevronUpIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#bdbdbd"))
        sortPriceUp.image = chevronUpIcon?.image(with: CGSize.init(width: 8, height: 8))
        
        let chevronDownIcon = FAKFontAwesome.chevronDownIcon(withSize: 8)
        chevronDownIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor("#bdbdbd"))
        sortPriceDown.image = chevronDownIcon?.image(with: CGSize.init(width: 8, height: 8))
    }
    
    @objc private func updateSortBar(_ sender: UITapGestureRecognizer) {
        let grey400 = UIColor("#bdbdbd")
        let grey900 = UIColor("#212121")
        sortMultiple.textColor = grey400
        sortSales.textColor = grey400
        sortCommission.textColor = grey400
        sortPrice.textColor = grey400
        
        let chevronUpIcon = FAKFontAwesome.chevronUpIcon(withSize: 8)
        chevronUpIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey400)
        sortPriceUp.image = chevronUpIcon?.image(with: CGSize.init(width: 8, height: 8))
        
        let chevronDownIcon = FAKFontAwesome.chevronDownIcon(withSize: 8)
        chevronDownIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey400)
        sortPriceDown.image = chevronDownIcon?.image(with: CGSize.init(width: 8, height: 8))
        
        switch sender.view! {
        case sortMultiple:
            sort = ProductDataSource.SORT_MULTIPLE
            sortMultiple.textColor = grey900
            break
        case sortSales:
            sort = ProductDataSource.SORT_SALES
            sortSales.textColor = grey900
            break
        case sortCommission:
            sort = ProductDataSource.SORT_COMMISSION
            sortCommission.textColor = grey900
            break
        default:
            sortPrice.textColor = grey900
            if sort == ProductDataSource.SORT_PRICE_UP {
                sort = ProductDataSource.SORT_PRICE_DOWN
                let chevronDownIcon = FAKFontAwesome.chevronDownIcon(withSize: 8)
                chevronDownIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey900)
                sortPriceDown.image = chevronDownIcon?.image(with: CGSize.init(width: 8, height: 8))
            } else {
                sort = ProductDataSource.SORT_PRICE_UP
                let chevronUpIcon = FAKFontAwesome.chevronUpIcon(withSize: 8)
                chevronUpIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: grey900)
                sortPriceUp.image = chevronUpIcon?.image(with: CGSize.init(width: 8, height: 8))
            }
            break
        }
    }
    
    private func initProductList() {
        productList.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        productListFlowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        
        let productDataSource = ProductDataSource(brandItem!)
        
        let productCellFactory: (UICollectionView, Int, Product) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = self.productList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCell
            cell.thumb.kf.setImage(with: URL(string: element.thumb!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                if let tmp = image {
                    let radio = tmp.size.width / tmp.size.height
                    if let constraint = (cell.thumb.constraints.filter{$0.firstAttribute == .height}.first) {
                        let itemWidth = (self.view.frame.size.width - 10) / 2
                        let height = itemWidth / radio
                        constraint.constant = height
                    }
                }
            })
            cell.title.text = element.title
            cell.price.text = "¥ \(element.price!)"
            cell.sales.text = "月销\(element.sales!)笔"
            return cell
        }
        
        let productListHelper = MVCHelper<Product>(productList)
        
        productListHelper.set(dataSource: productDataSource)
        productListHelper.set(cellFactory: productCellFactory)
        
        productListHelper.refresh()
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
