import SwiftUI

struct GoalPicker: View {
    
    @Binding var selection: UserProfile.Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Цель")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                ForEach(UserProfile.Goal.allCases, id: \.self) { goal in
                    Button {
                        selection = goal
                    } label: {
                        HStack {
                            Image(systemName: iconForGoal(goal))
                            Text(labelForGoal(goal))
                                .font(.subheadline.bold())
                            Spacer()
                            if selection == goal {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .foregroundStyle(selection == goal ? .blue : .primary)
                        .padding()
                        .background(selection == goal ? Color.blue.opacity(0.1) : Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
    
    private func iconForGoal(_ goal: UserProfile.Goal) -> String {
        switch goal {
        case .lose: return "arrow.down.circle.fill"
        case .maintain: return "equal.circle.fill"
        case .gain: return "arrow.up.circle.fill"
        }
    }
    
    private func labelForGoal(_ goal: UserProfile.Goal) -> String {
        switch goal {
        case .lose: return "Похудеть"
        case .maintain: return "Поддерживать вес"
        case .gain: return "Набрать массу"
        }
    }
    
}
