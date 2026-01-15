import Foundation

struct AppError: Identifiable, Error {
    
    let id = UUID()
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    init(from error: Error) {
        self.message = error.localizedDescription
    }
    
}
