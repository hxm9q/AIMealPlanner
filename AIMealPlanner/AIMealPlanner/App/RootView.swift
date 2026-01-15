import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        Group {
            switch authVM.authState {
            case .loading:
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .signedOut:
                AuthView()
                
            case .signedIn:
                MainTabView()
                
            case .error:
                VStack {
                    Text("Ошибка авторизации")
                    Button("Попробовать снова") {
                    }
                }
            }
        }
    }
    
}
