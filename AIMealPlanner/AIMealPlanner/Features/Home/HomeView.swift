import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject var viewModel: HomeViewModel
    @State private var showingPlanDetail = false
    
    @State private var availableWidth: CGFloat = 320
    @StateObject private var native = NativeAdManager()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    DailyCaloriesCard(calories: viewModel.dailyCalories)
                    
                    ActionSection(viewModel: viewModel)
                    
                    GeometryReader { geo in
                        BannerAdView(width: geo.size.width)
                            .frame(width: geo.size.width, height: 50, alignment: .center)
                            .background(.ultraThinMaterial)
                            .overlay(Divider(), alignment: .top)
                            .ignoresSafeArea(edges: .bottom)
                            .onAppear { availableWidth = geo.size.width }
                    }
                    
                    Spacer(minLength: 12)
                    
                    if let ad = native.loadedNativeAds.first {
                        SimpleNativeAdView(nativeAd: ad)
                            .frame(height: 220)
                            .padding(.horizontal, 16)
                            .onAppear {
                                print("Показана native реклама")
                                 native.popAd()
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 220)
                            .overlay(
                                Text("Загружается native реклама...")
                                    .foregroundColor(.gray)
                            )
                            .padding(.horizontal, 16)
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}
