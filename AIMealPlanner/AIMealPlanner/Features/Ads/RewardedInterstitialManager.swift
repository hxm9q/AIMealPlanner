import GoogleMobileAds
import Combine
import Foundation

final class RewardedInterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    
    private let adUnitID = AdMobConfig.rewardedInterstitial.rawValue
    
    private var rewardedInterstitialAd: RewardedInterstitialAd?
    
    var onRewardEarned: (() -> Void)?
    
    func load() {
        let request = Request()
        
        RewardedInterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error {
                Logger.log(.error, "Rewarded Interstitial load error: \(error.localizedDescription)")
                return
            }
            
            self?.rewardedInterstitialAd = ad
            self?.rewardedInterstitialAd?.fullScreenContentDelegate = self
            Logger.log(.info, "Rewarded Interstitial loaded successfully")
        }
    }
    
    func present(onReward: (() -> Void)? = nil) {
        if let onReward {
            self.onRewardEarned = onReward
        }
        
        guard let rootVC = UIApplication.shared.firstKeyWindowRootViewController() else {
            Logger.log(.warning, "No root VC for rewarded interstitial")
            return
        }
        
        guard let rewardedInterstitialAd else {
            Logger.log(.info, "Rewarded Interstitial not loaded → loading")
            load()
            return
        }
        
        rewardedInterstitialAd.present(from: rootVC) { [weak self] in
            Logger.log(.info, "User earned reward in Rewarded Interstitial!")
            self?.onRewardEarned?()
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Logger.log(.info, "Rewarded Interstitial dismissed → loading next")
        rewardedInterstitialAd = nil
        load()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Logger.log(.error, "Failed to present rewarded interstitial: \(error.localizedDescription)")
        rewardedInterstitialAd = nil
        load()
    }
    
    func adDidEarnReward(_ ad: FullScreenPresentingAd, reward: AdReward) {
        Logger.log(.info, "User earned reward in Rewarded Interstitial: \(reward.amount) \(reward.type)")
        onRewardEarned?()
    }
    
}
