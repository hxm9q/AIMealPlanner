import Foundation
import Combine
import GoogleMobileAds

final class AdService: ObservableObject {
    
    static let shared = AdService()
    
    let interstitial = InterstitalAdManager()
    let rewarded = RewardedAdManager()
    let rewardedInterstitial = RewardedInterstitialAdManager()
    let native = NativeAdManager()
    
    private var interstitialShowCountSinceLaunch = 0
    private let maxInterstitialPerSession = 3
    private let minIntervalBetweenInterstitial: TimeInterval = 120
    
    private var lastInterstitialShowTime: Date?
    
    private init() {
        interstitial.load()
        rewarded.load()
        rewardedInterstitial.load()
        native.load()
        Logger.log(.info, "AdService → все форматы предзагружены")
    }
    
    func presentInterstitial() {
        guard interstitialShowCountSinceLaunch < maxInterstitialPerSession else {
            Logger.log(.info, "Interstitial → лимит показов за сессию достигнут")
            return
        }
        
        if let last = lastInterstitialShowTime,
           Date().timeIntervalSince(last) < minIntervalBetweenInterstitial {
            Logger.log(.info, "Interstitial → слишком рано после предыдущего показа")
            return
        }
        
        interstitial.present()
        interstitialShowCountSinceLaunch += 1
        lastInterstitialShowTime = Date()
    }
    
    func presentRewarded(onReward: @escaping () -> Void) {
        rewarded.present { [weak self] in
            onReward()
            Logger.log(.info, "Rewarded → награда выдана пользователю")
        }
    }
    
    func presentRewardedInterstitial(onReward: @escaping () -> Void = {}) {
        rewardedInterstitial.present(onReward: onReward)
    }
    
    var hasReadyNativeAd: Bool {
        !native.loadedNativeAds.isEmpty
    }
    
    func popNativeAd() -> NativeAd? {
        native.popAd()
    }
    
    func loadMoreNativeIfNeeded() {
        if native.loadedNativeAds.count < 2 {
            native.load()
        }
    }
    
}
