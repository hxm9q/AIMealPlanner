import SwiftUI

struct ActionSection: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationLink {
                PlannerView(homeViewModel: viewModel)
            } label: {
                Label("Сгенерировать план на сегодня/завтра", systemImage: "calendar.badge.plus")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.9))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            NavigationLink {
                EditProfileView(viewModel: viewModel)
            } label: {
                Label("Редактировать профиль", systemImage: "pencil.circle")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
}
