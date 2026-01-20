import GoogleMobileAds
import Combine
import Foundation

final class AppOpenAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    
    private let adUnitID = AdMobConfig.appOpen.rawValue
    private var appOpenAd: AppOpenAd?
    
    var onAdPresented: (() -> Void)?
    var onAdDismissed: (() -> Void)?
    
    private var lastShownDate: Date? {
        get { UserDefaults.standard.object(forKey: "lastAppOpenAdShown") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "lastAppOpenAdShown") }
    }
    
    private var canShowAd: Bool {
        guard let last = lastShownDate else { return true }
        let hoursSinceLast = Date().timeIntervalSince(last) / 3600
        return hoursSinceLast >= 4
    }
    
    func load() {
        let request = Request()
        
        AppOpenAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error {
                Logger.log(.error, "App Open load error: \(error.localizedDescription)")
                return
            }
            
            self?.appOpenAd = ad
            self?.appOpenAd?.fullScreenContentDelegate = self
            
            self?.appOpenAd?.paidEventHandler = { adValue in
                let price = adValue.value.doubleValue / 1_000_000.0
                let currency = adValue.currencyCode
                let precisionStr: String
                
                switch adValue.precision {
                case .unknown:
                    precisionStr = "unknown"
                case .estimated:
                    precisionStr = "estimated"
                case .publisherProvided:
                    precisionStr = "publisherProvided"
                case .precise:
                    precisionStr = "precise"
                @unknown default:
                    precisionStr = "unknown-default"
                }
                
                Logger.log(.info, "Interstitial → paid impression: \(String(format: "%.4f", price)) \(currency) (precision: \(precisionStr))")
            }
            
            Logger.log(.info, "App Open loaded successfully")
        }
    }
    
    func present() {
        guard canShowAd else {
            Logger.log(.info, "App Open skipped: cooldown not passed")
            return
        }
        
        guard let rootVC = UIApplication.shared.firstKeyWindowRootViewController() else {
            Logger.log(.warning, "No root VC for app open")
            return
        }
        
        guard let appOpenAd else {
            Logger.log(.info, "App Open not loaded → loading")
            load()
            return
        }
        
        appOpenAd.present(from: rootVC)
        lastShownDate = Date()
        onAdPresented?()
    }
    
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        Logger.log(.info, "App Open dismissed → loading next")
        appOpenAd = nil
        load()
        onAdDismissed?()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Logger.log(.error, "Failed to present app open: \(error.localizedDescription)")
        appOpenAd = nil
        load()
    }
    
    func adDidRecordImpression(_ ad: any FullScreenPresentingAd) {
        Logger.log(.info, "AppOpen → impression засчитан")
    }
    
    func adDidRecordClick(_ ad: any FullScreenPresentingAd) {
        Logger.log(.info, "AppOpen → клик засчитан")
    }
    
}
