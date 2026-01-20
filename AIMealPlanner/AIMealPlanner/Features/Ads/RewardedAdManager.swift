import GoogleMobileAds
import Combine
import Foundation

final class RewardedAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    
    private let adUnitID = AdMobConfig.rewarded.rawValue
    private var rewardedAd: RewardedAd?
    
    var onRewardEarned: (() -> Void)?
    
    func load() {
        let request = Request()
        
        RewardedAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error {
                Logger.log(.error, "Rewarded load error: \(error.localizedDescription)")
                return
            }
            
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            Logger.log(.info, "Rewarded loaded successfully")
        }
    }
    
    func present(onReward: (() -> Void)? = nil) {
        if let onReward {
            self.onRewardEarned = onReward
        }
        
        guard let rootVC = UIApplication.shared.firstKeyWindowRootViewController() else {
            Logger.log(.warning, "No root view controller found for rewarded ad")
            return
        }
        
        guard let rewardedAd else {
            Logger.log(.info, "Rewarded ad not loaded → starting load")
            load()
            return
        }
        
        rewardedAd.present(from: rootVC) { [weak self] in
            Logger.log(.info, "User earned reward!")
            self?.onRewardEarned?()
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        Logger.log(.info, "Rewarded dismissed → loading next")
        self.rewardedAd = nil
        self.load()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Logger.log(.error, "Failed to present rewarded: \(error)")
        self.rewardedAd = nil
        self.load()
    }
    
}
