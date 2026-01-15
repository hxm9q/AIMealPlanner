import SwiftUI

struct GenderPicker: View {
    
    @Binding var selection: UserProfile.Gender
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Пол")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(UserProfile.Gender.allCases, id: \.self) { gender in
                    Button {
                        selection = gender
                    } label: {
                        HStack {
                            Image(systemName: gender == .male ? "figure.stand" : "figure.stand.dress")
                            Text(gender.rawValue.capitalized)
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(selection == gender ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selection == gender ? Color.blue : Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
    
}
