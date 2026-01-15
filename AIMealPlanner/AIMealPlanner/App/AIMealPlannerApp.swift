import SwiftUI
import FirebaseCore

@main
struct AIMealPlannerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AuthViewModel())
        }
    }
    
}
