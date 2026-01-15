import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    UserProfileSection()
                    
                    SettingsSection(title: "Основные", icon: "gear") {
                        SettingsRow(
                            icon: "person.circle.fill",
                            title: "Редактировать профиль",
                            iconColor: .blue,
                            destination: AnyView(EditProfileView(viewModel: homeViewModel))
                        )
                        
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Уведомления",
                            iconColor: .orange,
                            destination: AnyView(NotificationsPlaceholder())
                        )
                    }
                    
                    SettingsSection(title: "О приложении", icon: "info.circle") {
                        SettingsRowSimple(
                            icon: "doc.text.fill",
                            title: "Политика конфиденциальности",
                            iconColor: .purple
                        )
                        
                        SettingsRowSimple(
                            icon: "checkmark.shield.fill",
                            title: "Условия использования",
                            iconColor: .green
                        )
                        
                        HStack {
                            Label("Версия", systemImage: "app.badge")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("1.0.0")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button {
                        showingLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Выйти из аккаунта")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.top, 16)
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Выход", isPresented: $showingLogoutAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Выйти", role: .destructive) {
                    authVM.signOut()
                }
            } message: {
                Text("Вы уверены, что хотите выйти из аккаунта?")
            }
        }
    }
    
}

struct NotificationsPlaceholder: View {
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.badge")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            
            Text("Настройки уведомлений")
                .font(.title2.bold())
            
            Text("В разработке")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Уведомления")
    }
    
}
