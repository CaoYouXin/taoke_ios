//
//  MessageController.swift
//  TaoKe
//
//  Created by jason tsang on 11/25/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxSwift
import RxBus
import UserNotifications

class MessageController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initBadge()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initBadge() {
        RxBus.shared.asObservable(event: Events.Message.self).rxSchedulerHelper().subscribe { event in
            if let message = event.element {
                self.tabBarItem.badgeValue = message.count == 0 ? nil : "\(message.count)"
                UIApplication.shared.applicationIconBadgeNumber = message.count
            }
        }.disposed(by: disposeBag)
        
        //test show
        Observable<Int>.timer(RxTimeInterval(2), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { _ in
                RxBus.shared.post(event: Events.Message(count: 6))
            })
    }
}
