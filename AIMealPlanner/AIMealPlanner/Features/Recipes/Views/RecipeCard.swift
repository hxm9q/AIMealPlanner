import SwiftUI

struct RecipeCard: View {
    
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL = recipe.image, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 160)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 160)
                            .foregroundStyle(.gray)
                    case .empty:
                        ProgressView()
                            .frame(height: 160)
                    @unknown default:
                        EmptyView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text(recipe.title)
                .font(.headline)
                .lineLimit(2)
            
            HStack {
                if let minutes = recipe.readyInMinutes {
                    Label("\(minutes) мин", systemImage: "clock")
                }
                Spacer()
                if let servings = recipe.servings {
                    Label("\(servings) порц.", systemImage: "person.2")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            if let calories = recipe.caloriesPerServing {
                Text("\(Int(calories)) ккал/порция")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 8)
    }
    
}
