import AppsFlyerLib
import AppTrackingTransparency
import FirebaseAnalytics
import AppMetricaCore

extension AppDelegate {

    func configureAppsFlyer() {
        let appsFlyer = AppsFlyerLib.shared()

        appsFlyer.appsFlyerDevKey = Secrets.apps_flyer_key.rawValue
        appsFlyer.appleAppID = Secrets.apps_flyer_bundle.rawValue

//#if DEBUG
//        appsFlyer.isDebug = true
//#else
//        appsFlyer.isDebug = false
//#endif
        
        appsFlyer.isDebug = false

        appsFlyer.waitForATTUserAuthorization(timeoutInterval: 60)
        appsFlyer.delegate = self

        Logger.log(.info, "AppsFlyer configured — waiting for ATT")
    }
}

// MARK: - AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate {

    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        Logger.log(.info, "AppsFlyer → onConversionDataSuccess")

        logIfExists(conversionInfo, key: "af_status", title: "Install status")
        logIfExists(conversionInfo, key: "campaign", title: "Campaign")
        logIfExists(conversionInfo, key: "media_source", title: "Media source")

        let params = conversionInfo as? [String: Any] ?? [:]

        AppMetrica.reportEvent(
            name: "appsflyer_attribution_received",
            parameters: params
        )

        Analytics.logEvent(
            "appsflyer_attribution_received",
            parameters: params
        )
    }

    func onConversionDataFail(_ error: Error) {
        Logger.log(.error, "AppsFlyer → onConversionDataFail: \(error.localizedDescription)")

        let params = ["error": error.localizedDescription]

        AppMetrica.reportEvent(
            name: "appsflyer_attribution_failed",
            parameters: params
        )

        Analytics.logEvent(
            "appsflyer_attribution_failed",
            parameters: params
        )
    }

    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        Logger.log(.info, "AppsFlyer → onAppOpenAttribution: \(attributionData)")
    }

    func onAppOpenAttributionFailure(_ error: Error) {
        Logger.log(.error, "AppsFlyer → onAppOpenAttributionFailure: \(error.localizedDescription)")
    }
    
}
