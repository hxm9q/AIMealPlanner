import SwiftUI

struct DailyCaloriesCard: View {
    
    let calories: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Суточная норма")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Text("\(calories) ккал")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.green)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 4)
    }
    
}
