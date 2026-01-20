import GoogleMobileAds

extension AppDelegate {
    
    func configureAdMob() {
        MobileAds.shared.start { status in }
        
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [
            "f7ac8c992b28855d70b4e440a542a8ec"
        ]
    }
    
}
