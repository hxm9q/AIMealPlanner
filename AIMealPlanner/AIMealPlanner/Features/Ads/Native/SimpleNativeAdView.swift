import SwiftUI
import GoogleMobileAds

struct SimpleNativeAdView: UIViewRepresentable {
    
    let nativeAd: NativeAd?
    
    func makeUIView(context: Context) -> NativeAdView {
        let adView = NativeAdView()
        adView.backgroundColor = .systemGray6
        adView.layer.cornerRadius = 12
        adView.clipsToBounds = true
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(stack)
        
        let headline = UILabel()
        headline.font = .systemFont(ofSize: 17, weight: .bold)
        headline.numberOfLines = 2
        
        let cta = UIButton(type: .system)
        cta.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        cta.backgroundColor = .systemBlue
        cta.setTitleColor(.white, for: .normal)
        cta.layer.cornerRadius = 8
        
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.spacing = 12
        topRow.alignment = .center
        
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.backgroundColor = .systemGray5
        icon.layer.cornerRadius = 8
        
        let media = MediaView()
        media.contentMode = .scaleAspectFit
        
        topRow.addArrangedSubview(icon)
        topRow.addArrangedSubview(media)
        
        stack.addArrangedSubview(headline)
        stack.addArrangedSubview(topRow)
        stack.addArrangedSubview(cta)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: adView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -12),
            
            icon.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 48),
            
            media.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        adView.headlineView = headline
        adView.callToActionView = cta
        adView.iconView = icon
        adView.mediaView = media
        
        return adView
    }
    
    func updateUIView(_ uiView: NativeAdView, context: Context) {
        guard let ad = nativeAd else {
            (uiView.headlineView as? UILabel)?.text = "Тестовая реклама"
            (uiView.callToActionView as? UIButton)?.setTitle("Загрузка...", for: .normal)
            (uiView.iconView as? UIImageView)?.image = nil
            uiView.nativeAd = nil
            return
        }
        
        (uiView.headlineView as? UILabel)?.text = ad.headline ?? "Без заголовка"
        (uiView.callToActionView as? UIButton)?.setTitle(ad.callToAction ?? "Перейти", for: .normal)
        (uiView.iconView as? UIImageView)?.image = ad.icon?.image
        
        uiView.nativeAd = ad
    }
    
}
