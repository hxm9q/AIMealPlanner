import FirebaseCore
import FirebaseAnalytics

extension AppDelegate {

    func configureFirebase() {
        FirebaseApp.configure()
        Logger.log(.info, "Firebase configured successfully")

        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        Logger.log(.info, "Firebase Analytics enabled")
    }
    
}
