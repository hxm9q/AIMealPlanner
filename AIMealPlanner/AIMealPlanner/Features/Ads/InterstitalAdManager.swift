import GoogleMobileAds
import Combine
import Foundation

final class InterstitalAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    
    private let adUnitID = AdMobConfig.interstitial.rawValue
    private var interstitial: InterstitialAd?
    
    func load() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error { Logger.log(.error, "Interstitial load error: \(error.localizedDescription)"); return }
            
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            
            self?.interstitial?.paidEventHandler = { adValue in
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
            
            Logger.log(.info, "Interstitial loaded successfully")
        }
    }
    
    func present() {
        guard let root = UIApplication.shared.firstKeyWindowRootViewController() else {
            Logger.log(.warning, "Interstitial → нет rootViewController для показа")
            return
        }
        guard let interstitial else {
            Logger.log(.info, "Loading interstitial"); load(); return
        }
        
        Logger.log(.info, "Interstitial → пытаемся показать")
        interstitial.present(from: root)
    }
    
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        Logger.log(.info, "Interstitial → закрыт пользователем")
        self.interstitial = nil
        self.load()
    }
    
    func ad(_ ad: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        Logger.log(.error, "Interstitial → ошибка показа: \(error.localizedDescription) (code: \((error as NSError).code))")
        self.interstitial = nil
        self.load()
    }
    
    func adDidRecordImpression(_ ad: any FullScreenPresentingAd) {
        Logger.log(.info, "Interstitial → impression засчитан")
    }
    
}
