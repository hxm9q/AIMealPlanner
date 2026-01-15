import SwiftUI

struct SectionHeader: View {
    
    let title: String
    let icon: String
    
    var body: some View {
        Label(title, systemImage: icon)
            .font(.title3.bold())
            .foregroundStyle(.primary)
    }
    
}

struct EditProfileView: View {
    
    @StateObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingSaveAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Основные параметры", icon: "person.fill")
                    
                    VStack(spacing: 12) {
                        GenderPicker(selection: $viewModel.userProfile.gender)
                        
                        CustomStepperInt(
                            value: $viewModel.userProfile.age,
                            title: "Возраст",
                            range: 16...100,
                            step: 1,
                            unit: "лет"
                        )
                        
                        CustomStepper(
                            value: $viewModel.userProfile.weightKg,
                            title: "Вес",
                            range: 40...200,
                            step: 0.5,
                            unit: "кг",
                            format: "%.1f"
                        )
                        
                        CustomStepper(
                            value: $viewModel.userProfile.heightCm,
                            title: "Рост",
                            range: 120...220,
                            step: 1,
                            unit: "см",
                            format: "%.0f"
                        )
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Цели и активность", icon: "target")
                    
                    VStack(spacing: 12) {
                        GoalPicker(selection: $viewModel.userProfile.goal)
                        
                        Divider()
                        
                        ActivityPicker(selection: $viewModel.userProfile.activityLevel)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Пищевые особенности", icon: "leaf.fill")
                    
                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Аллергии", systemImage: "exclamationmark.triangle.fill")
                                .font(.subheadline.bold())
                                .foregroundStyle(.orange)
                            
                            TextField("Через запятую", text: Binding(
                                get: { viewModel.userProfile.allergies.joined(separator: ", ") },
                                set: { viewModel.userProfile.allergies = $0.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) } }
                            ))
                            .textFieldStyle(.roundedBorder)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Предпочтения", systemImage: "heart.fill")
                                .font(.subheadline.bold())
                                .foregroundStyle(.pink)
                            
                            TextField("Через запятую", text: Binding(
                                get: { viewModel.userProfile.preferences.joined(separator: ", ") },
                                set: { viewModel.userProfile.preferences = $0.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) } }
                            ))
                            .textFieldStyle(.roundedBorder)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Суточная норма")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            Text("\(viewModel.dailyCalories) ккал")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.green)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.calculateDailyCalories()
                            }
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.title2)
                                .foregroundStyle(.blue)
                                .padding(12)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    Text("Рассчитано на основе ваших параметров и целей")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.green.opacity(0.1), Color.green.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
                
                Button {
                    viewModel.saveProfile()
                    showingSaveAlert = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Сохранить изменения")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Редактировать профиль")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadProfile()
        }
        .onChange(of: viewModel.userProfile) { _, _ in
            viewModel.calculateDailyCalories()
        }
        .alert("Сохранено", isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Ваш профиль успешно обновлен")
        }
    }
    
}

fileprivate struct CustomStepperInt: View {
    
    @Binding var value: Int
    
    let title: String
    let range: ClosedRange<Int>
    let step: Int
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            HStack {
                Text("\(value)")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                
                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button {
                        if value > range.lowerBound {
                            value = max(range.lowerBound, value - step)
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    
                    Button {
                        if value < range.upperBound {
                            value = min(range.upperBound, value + step)
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
    
}

fileprivate struct CustomStepper: View {
    
    @Binding var value: Double
    let title: String
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    let format: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            HStack {
                Text(String(format: format, value))
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                
                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button {
                        if value > range.lowerBound {
                            value = max(range.lowerBound, value - step)
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    
                    Button {
                        if value < range.upperBound {
                            value = min(range.upperBound, value + step)
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
    
}
