import SwiftUI

struct ErrorView: View {
    
    let error: AppError
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(error.message)
            Button("Retry") {
                retryAction()
            }
        }
    }
    
}
