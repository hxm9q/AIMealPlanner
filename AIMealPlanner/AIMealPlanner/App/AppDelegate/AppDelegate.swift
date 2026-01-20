import UIKit
import GoogleMobileAds

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        configureFirebase()
        configureAppMetrica()
        configureAppsFlyer()
        configureAdMob()
        
        return true
    }
    
}

extension AppDelegate {
    
    func logIfExists(
        _ dictionary: [AnyHashable: Any],
        key: String,
        title: String
    ) {
        if let value = dictionary[key] as? String {
            Logger.log(.info, "\(title): \(value)")
        }
    }
    
}
