import SwiftUI

struct PlannerView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @StateObject private var viewModel = PlannerViewModel()
    @StateObject private var historyViewModel = HistoryViewModel()
    @State private var showingSaveAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileQuickView(profile: homeViewModel.userProfile)
                    
                    Section {
                        Stepper("Количество дней: \(viewModel.daysCount)", value: $viewModel.daysCount, in: 1...7)
                        
                        Picker("Диета", selection: $viewModel.diet) {
                            Text("Без ограничений").tag("")
                            Text("Вегетарианская").tag("vegetarian")
                            Text("Веганская").tag("vegan")
                            Text("Кето").tag("keto")
                            
                        }
                    } header: {
                        Text("Параметры плана")
                            .font(.headline)
                    }
                    
                    if viewModel.isGenerating {
                        ProgressView("Генерирую план...")
                            .padding()
                    } else if let plan = viewModel.generatedPlan {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ваш план питания")
                                .font(.title2.bold())
                            
                            Spacer()
                            
                            Button {
                                historyViewModel.savePlan(
                                    content: plan,
                                    daysCount: viewModel.daysCount,
                                    diet: viewModel.diet
                                )
                                showingSaveAlert = true
                            } label: {
                                Label("Сохранить", systemImage: "square.and.arrow.down.fill")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.green)
                                    .clipShape(Capsule())
                            }
                            
                            Text(plan)
                                .font(.body)
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Сгенерировать план") {
                        Task {
                            await viewModel.generatePlan(profile: homeViewModel.userProfile)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(viewModel.isGenerating)
                }
                .padding()
            }
            .navigationTitle("Planner")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Сохранено", isPresented: $showingSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("План добавлен в историю")
            }
        }
    }
    
}

struct ProfileQuickView: View {
    
    let profile: UserProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ваши текущие параметры")
                .font(.headline)
            
            Text("Возраст: \(profile.age) лет")
            Text("Вес: \(profile.weightKg, specifier: "%.1f") кг")
            Text("Рост: \(profile.heightCm, specifier: "%.0f") см")
            Text("Цель: \(profile.goal.rawValue)")
            Text("Активность: \(profile.activityLevel.rawValue)")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 2)
    }
    
}
