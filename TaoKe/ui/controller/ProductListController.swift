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
    
    var brandItem: BrandItem?
    
    var sort: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize.init(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = brandItem!.title!
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
