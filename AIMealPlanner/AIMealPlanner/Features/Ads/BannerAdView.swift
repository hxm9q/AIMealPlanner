import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    
    let adUnitID = AdMobConfig.banner.rawValue
    let width: CGFloat
    
    func makeUIView(context: Context) -> BannerView {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        let banner = BannerView(adSize: adSize)
        
        banner.adUnitID = adUnitID
        banner.delegate = context.coordinator
        banner.rootViewController = UIApplication.shared.firstKeyWindowRootViewController()
        banner.load(Request())
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        let newSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        
        if !CGSizeEqualToSize(newSize.size, uiView.adSize.size) {
            uiView.adSize = newSize
            uiView.load(Request())
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator: NSObject, BannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            Logger.log(.info, "Banner → успешно загружен (adUnit: \(bannerView.adUnitID ?? "unknown"))")
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: any Error) {
            Logger.log(.error, "Banner → ошибка загрузки: \(error.localizedDescription) (code: \((error as NSError).code))")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            Logger.log(.info, "Banner → будет показан клик (откроется overlay)")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
            Logger.log(.info, "Banner → overlay будет закрыт")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            Logger.log(.info, "Banner → overlay закрыт")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
            Logger.log(.info, "Banner → impression засчитан")
        }
    }
    
}
