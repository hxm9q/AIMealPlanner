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
            Logger.log(.info, "Interstitial loaded successfully")
        }
    }
    
    func present() {
        guard let root = UIApplication.shared.firstKeyWindowRootViewController() else { return }
        guard let interstitial else {
            Logger.log(.info, "Loading interstitial"); load(); return
        }
        interstitial.present(from: root)
    }
    
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        Logger.log(.info, "Dismissed loading next")
        self.interstitial = nil
        self.load()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Logger.log(.error, "Failed to present interstitial \(error)")
        self.interstitial = nil
        self.load()
    }
    
}
