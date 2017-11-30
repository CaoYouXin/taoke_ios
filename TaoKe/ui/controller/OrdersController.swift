//
//  OrdersController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/30.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import UIKit
import FontAwesomeKit

class OrdersController: UIViewController {

    @IBOutlet weak var allBtn: UIView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allIndicator: UIView!
    
    @IBOutlet weak var effectiveBtn: UIView!
    @IBOutlet weak var effectiveLabel: UILabel!
    @IBOutlet weak var effectiveIndicator: UIView!
    
    @IBOutlet weak var ineffectiveBtn: UIView!
    @IBOutlet weak var ineffectiveLabel: UILabel!
    @IBOutlet weak var ineffectiveIndecator: UIView!
    
    @IBOutlet weak var payedBtn: UIView!
    @IBOutlet weak var payedLabel: UILabel!
    
    @IBOutlet weak var deliveredBtn: UIView!
    @IBOutlet weak var deliveredLabel: UILabel!
    
    @IBOutlet weak var settledBtn: UIView!
    @IBOutlet weak var settledLabel: UILabel!
    
    @IBOutlet weak var secondSelection: UIStackView!
    @IBOutlet weak var secondSelectionHeight: NSLayoutConstraint!
    
    private var trans = UIColor.init(hue: 0, saturation: 0, brightness: 0, alpha: 0).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "订单详情"
        
        allIndicator.layer.backgroundColor = trans
        effectiveIndicator.layer.backgroundColor = UIColor.orange.cgColor
        ineffectiveIndecator.layer.backgroundColor = trans
        
        settledLabel.layer.backgroundColor = UIColor.orange.cgColor
        settledLabel.layer.cornerRadius = 15
        settledLabel.textColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
