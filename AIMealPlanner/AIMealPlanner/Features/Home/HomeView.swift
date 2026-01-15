import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject var viewModel: HomeViewModel
    @State private var showingPlanDetail = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    DailyCaloriesCard(calories: viewModel.dailyCalories)
                    
                    ActionSection(viewModel: viewModel)
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}
