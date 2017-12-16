
import UIKit
import RestKit
import CleanroomLogger
import UserNotifications
import AlibcTradeBiz

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Bugly.start(withAppId: "e1813186f2")
        
        RKlcl_configure_by_name("RestKit/Network", RKlcl_vTrace.rawValue);
        RKlcl_configure_by_name("RestKit/ObjectMapping", RKlcl_vOff.rawValue);
        Log.enable()
        Log.info?.message("The application has finished launching.")
        RxDataHook.add(ApiErrorHook())
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if error != nil {
                Log.error?.message(error!.localizedDescription)
            }
        }

        AlibcTradeSDK.sharedInstance().asyncInit(success: { () in
            print("alibc init success")
            AlibcTradeSDK.sharedInstance().setIsForceH5(false)
        }, failure: { (error) in
            print("alibc init fail \(error.debugDescription)")
        })
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    
}

