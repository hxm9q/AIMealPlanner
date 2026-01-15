import SwiftUI

struct PlanCard: View {
    
    let plan: MealPlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("План на \(plan.daysCount) \(daysWord)")
                        .font(.headline)
                    
                    Text(plan.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    
                    if !plan.diet.isEmpty {
                        Text(plan.dietLabel)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                    }
                }
            }
            
            Text(plan.content)
                .font(.subheadline)
                .lineLimit(3)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var daysWord: String {
        let lastDigit = plan.daysCount % 10
        let lastTwoDigits = plan.daysCount % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "дней"
        }
        
        switch lastDigit {
        case 1: return "день"
        case 2, 3, 4: return "дня"
        default: return "дней"
        }
    }
    
}
