import SwiftUI

struct ActivityPicker: View {
    
    @Binding var selection: UserProfile.ActivityLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Уровень активности")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                ForEach(UserProfile.ActivityLevel.allCases, id: \.self) { level in
                    Button {
                        selection = level
                    } label: {
                        HStack {
                            Image(systemName: iconForActivity(level))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(labelForActivity(level))
                                    .font(.subheadline.bold())
                                Text(descriptionForActivity(level))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if selection == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .foregroundStyle(selection == level ? .blue : .primary)
                        .padding()
                        .background(selection == level ? Color.blue.opacity(0.1) : Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
    
    private func iconForActivity(_ level: UserProfile.ActivityLevel) -> String {
        switch level {
        case .sedentary: return "figure.seated"
        case .light: return "figure.walk"
        case .moderate: return "figure.run"
        case .active: return "figure.strengthtraining.traditional"
        case .veryActive: return "flame.fill"
        }
    }
    
    private func labelForActivity(_ level: UserProfile.ActivityLevel) -> String {
        switch level {
        case .sedentary: return "Минимальная"
        case .light: return "Легкая"
        case .moderate: return "Умеренная"
        case .active: return "Высокая"
        case .veryActive: return "Очень высокая"
        }
    }
    
    private func descriptionForActivity(_ level: UserProfile.ActivityLevel) -> String {
        switch level {
        case .sedentary: return "Сидячий образ жизни"
        case .light: return "1-3 тренировки в неделю"
        case .moderate: return "3-5 тренировок в неделю"
        case .active: return "6-7 тренировок в неделю"
        case .veryActive: return "2 тренировки в день"
        }
    }
    
}
