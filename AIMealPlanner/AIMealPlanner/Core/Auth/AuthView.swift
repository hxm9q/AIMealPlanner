import SwiftUI

struct AuthView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(isSignUp ? "Регистрация" : "Вход")
                    .font(.largeTitle.bold())
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                SecureField("Пароль", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Button {
                    Task {
                        isLoading = true
                        if isSignUp {
                            await authVM.signUp(email: email, password: password)
                        } else {
                            await authVM.signIn(email: email, password: password)
                        }
                        isLoading = false
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text(isSignUp ? "Зарегистрироваться" : "Войти")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading || email.isEmpty || password.count < 6)
                
                Button {
                    isSignUp.toggle()
                } label: {
                    Text(isSignUp ? "Уже есть аккаунт? Войти" : "Нет аккаунта? Зарегистрироваться")
                        .foregroundStyle(.blue)
                }
                
                if !isSignUp {
                    Button("Забыли пароль?") {
                        Task { await authVM.resetPassword(email: email) }
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .padding()
            .navigationTitle(isSignUp ? "Регистрация" : "Вход")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}
