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
            Logger.log(.info, "Banner Loaded")
        }
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: any Error) {
            Logger.log(.error, "Banner Failed with error: \(error.localizedDescription)")
        }
    }
    
}
