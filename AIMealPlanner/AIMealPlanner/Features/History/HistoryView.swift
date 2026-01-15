import SwiftUI

struct HistoryView: View {
    
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedPlan: MealPlan?
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.plans.isEmpty {
                    EmptyHistoryView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.plans) { plan in
                                PlanCard(plan: plan)
                                    .onTapGesture {
                                        selectedPlan = plan
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            viewModel.deletePlan(plan)
                                        } label: {
                                            Label("Удалить", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Plans History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !viewModel.plans.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.clearAllPlans()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .sheet(item: $selectedPlan) { plan in
                PlanDetailView(plan: plan)
            }
        }
    }
    
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 80))
                .foregroundStyle(.gray.opacity(0.5))
            
            Text("История пуста")
                .font(.title2.bold())
            
            Text("Сгенерированные планы питания будут отображаться здесь")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
