import Foundation
import Combine

class BaseViewModel<T>: ObservableObject {
    
    @Published var viewState: ViewState<T> = .idle
    @Published var error: AppError? = nil
    
    func handleError(_ error: Error) {
        let appError = AppError(from: error)
        self.error = AppError(from: error)
        viewState = .error(appError)
    }
    
}
