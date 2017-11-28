//
//  TeamController.swift
//  TaoKe
//
//  Created by CaoYouxin on 2017/11/28.
//  Copyright © 2017年 jason tsang. All rights reserved.
//

import UIKit
import FontAwesomeKit
import MJRefresh

class TeamController: UIViewController {

    @IBOutlet weak var scrollWrapper: UIScrollView!
    @IBOutlet weak var teamDataList: UICollectionView!
    @IBOutlet weak var teamDataListLayout: UICollectionViewFlowLayout!
    
    private var teamDataHelper: MVCHelper<TeamDataView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: FAKFontAwesome.chevronLeftIcon(withSize: 15).image(with: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(back))
        navigationItem.title = "团队贡献"
        
        initMJRefresh()
        initTeamDataList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initTeamDataList() {
        teamDataHelper = MVCHelper<TeamDataView>(teamDataList)
        
        teamDataListLayout.itemSize = CGSize(width: view.frame.size.width, height: 50)
        
        let cellFactory: (UICollectionView, Int, TeamDataView) -> UICollectionViewCell = { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamDataCell", for: indexPath) as! TeamDataCell
            
            cell.name.text = element.name
            cell.commit.text = "贡献 \(element.amount!) 元"
            
            return cell
        }
        teamDataHelper?.set(cellFactory: cellFactory)
        
        teamDataHelper?.set(dataSource: TeamDataSource(self))
        teamDataHelper?.refresh()
    }
    
    private func initMJRefresh() {
        scrollWrapper.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.teamDataHelper?.refresh()
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.teamDataList.mj_header.endRefreshing()
            }
        })
    }

}
