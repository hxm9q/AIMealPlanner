import Foundation
import FirebaseAuth
import Combine

enum AuthState {
    case signedOut
    case signedIn(User)
    case loading
    case error(Error)
}

final class AuthViewModel: ObservableObject {
    
    @Published var authState: AuthState = .loading
    @Published var currentUser: User? = nil
    @Published var errorMessage: String? = nil
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self else { return }
            
            if let user = user {
                self.currentUser = user
                self.authState = .signedIn(user)
                Logger.log(.info, "Пользователь вошёл: \(user.uid) (\(user.email ?? "без email"))")
            } else {
                self.currentUser = nil
                self.authState = .signedOut
                Logger.log(.info, "Пользователь вышел или не авторизован")
            }
        }
    }
    
    deinit {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func signUp(email: String, password: String) async {
        authState = .loading
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            currentUser = result.user
            authState = .signedIn(result.user)
            
            Logger.log(.info, "Регистрация успешна: \(result.user.uid)")
        } catch {
            errorMessage = error.localizedDescription
            authState = .error(error)
            Logger.log(.error, "Ошибка регистрации: \(error.localizedDescription)")
        }
    }
    
    func signIn(email: String, password: String) async {
        authState = .loading
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            currentUser = result.user
            authState = .signedIn(result.user)
            
            Logger.log(.info, "Вход успешен: \(result.user.uid)")
        } catch {
            errorMessage = error.localizedDescription
            authState = .error(error)
            Logger.log(.error, "Ошибка входа: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            authState = .signedOut
            errorMessage = nil
            Logger.log(.info, "Пользователь вышел")
        } catch {
            errorMessage = error.localizedDescription
            Logger.log(.error, "Ошибка выхода: \(error.localizedDescription)")
        }
    }
    
    func resetPassword(email: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            Logger.log(.info, "Ссылка для сброса пароля отправлена на \(email)")
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            Logger.log(.error, "Ошибка отправки сброса пароля: \(error.localizedDescription)")
        }
    }
    
}
