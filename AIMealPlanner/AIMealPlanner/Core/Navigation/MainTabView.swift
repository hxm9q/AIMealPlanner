import SwiftUI

struct MainTabView: View {
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView(viewModel: homeViewModel)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                PlannerView(homeViewModel: homeViewModel)
            }
            .tabItem {
                Label("Planner", systemImage: "list.bullet.clipboard")
            }
            
            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }
            
            NavigationStack {
                RecipesView()
            }
            .tabItem {
                Label("Recipes", systemImage: "fork.knife.circle.fill")
            }
            
            NavigationStack {
                SettingsView(homeViewModel: homeViewModel)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
    }
    
}
