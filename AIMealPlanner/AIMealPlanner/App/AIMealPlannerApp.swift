import SwiftUI
import FirebaseCore
import AppsFlyerLib
import AppTrackingTransparency

@main
struct AIMealPlannerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AuthViewModel())
                .onAppear { requestATTIfNeeded() }
        }
    }
    
    private func requestATTIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if #available(iOS 14, *) {
                if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                    ATTrackingManager.requestTrackingAuthorization { status in
                        DispatchQueue.main.async {
                            let statusStr: String
                            switch status {
                            case .authorized:    statusStr = "authorized"
                            case .denied:        statusStr = "denied"
                            case .restricted:    statusStr = "restricted"
                            case .notDetermined: statusStr = "notDetermined"
                            @unknown default:    statusStr = "unknown"
                            }
                            Logger.log(.info, "ATT status: \(statusStr)")
                            
                            AppsFlyerLib.shared().start()
                            Logger.log(.info, "AppsFlyer started after ATT response")
                        }
                    }
                } else {
                    AppsFlyerLib.shared().start()
                    Logger.log(.info, "AppsFlyer started (ATT already determined)")
                }
            }
        }
    }
    
}
