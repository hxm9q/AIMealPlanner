import SwiftUI
import FirebaseAuth

struct UserProfileSection: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Text(initials)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 4) {
                Text(authVM.currentUser?.email ?? "Пользователь")
                    .font(.title3.bold())
                
                Text("Firebase Authentication")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var initials: String {
        guard let email = authVM.currentUser?.email else { return "?" }
        let components = email.components(separatedBy: "@")
        let name = components.first ?? "?"
        return String(name.prefix(2)).uppercased()
    }
    
}
