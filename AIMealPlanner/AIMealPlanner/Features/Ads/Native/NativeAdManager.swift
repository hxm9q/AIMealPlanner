import GoogleMobileAds
import Foundation
import Combine

final class NativeAdManager: NSObject, ObservableObject, NativeAdLoaderDelegate {
    
    private let adUnitID = AdMobConfig.native.rawValue
    private var adLoader: AdLoader?
    
    @Published var loadedNativeAds: [NativeAd] = []
    
    private let maxCachedAds = 3
    
    func load() {
        guard loadedNativeAds.count < maxCachedAds else { return }
        
        let options = [NativeAdMediaAdLoaderOptions() as GADAdLoaderOptions]
        
        adLoader = AdLoader(
            adUnitID: adUnitID,
            rootViewController: UIApplication.shared.firstKeyWindowRootViewController(),
            adTypes: [.native],
            options: options
        )
        
        adLoader?.delegate = self
        adLoader?.load(Request())
        
        Logger.log(.info, "Native ad load requested")
    }
    
    
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        Logger.log(.info, "Native ad loaded successfully")
        
        loadedNativeAds.append(nativeAd)
        
        if loadedNativeAds.count < maxCachedAds {
            load()
        }
    }
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        Logger.log(.error, "Native ad failed to load: \(error.localizedDescription)")
        
        load()
    }
    
    func popAd() -> NativeAd? {
        guard !loadedNativeAds.isEmpty else {
            Logger.log(.info, "Native → попытка pop, но кэш пуст")
            return nil
        }
        let ad = loadedNativeAds.removeFirst()
        Logger.log(.info, "Native → выдан из кэша (осталось: \(loadedNativeAds.count))")
        return ad
    }
    
}
