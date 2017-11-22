//
//  NewerGuideController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/20.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import CleanroomLogger
import UIKit
import RxSwift
import FontAwesomeKit

class NewerGuideController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var newerGuideList: UIStackView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "新手引导"
        newerGuideList.spacing = 0
        
        TaoKeApi.getNewerGuideList().rxSchedulerHelper().subscribe({ event in
            switch event {
            case .next(let urls):
                for url in urls! {
                    let imageView = UIImageView()
                    self.newerGuideList.addArrangedSubview(imageView)
                    self.newerGuideList.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0))
                    
                    imageView.kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                        if let img = image {
                            let ratio = img.size.height / img.size.width
                            let height = self.view.frame.width * ratio
                            
                            if let constraint = (self.newerGuideList.constraints.filter{$0.firstAttribute == .height && $0.firstItem!.isEqual(imageView)}.first) {
                                constraint.constant = height
                            }
                            
                            if let constraint = (self.newerGuideList.constraints.filter{$0.firstAttribute == .height && $0.firstItem!.isEqual(self.newerGuideList)}.first) {
                                constraint.constant += (height + self.newerGuideList.spacing)
                            }
                        }
                    })
                }
            case .error(let error):
                Log.error?.message(error.localizedDescription)
            case .completed:
                break;
            }
        }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
