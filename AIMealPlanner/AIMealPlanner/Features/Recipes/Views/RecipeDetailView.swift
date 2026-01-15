import SwiftUI

struct RecipeDetailView: View {
    
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = recipe.image, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Text(recipe.title)
                    .font(.title)
                    .bold()
                
                HStack(spacing: 20) {
                    if let minutes = recipe.readyInMinutes {
                        Label("\(minutes) мин", systemImage: "clock")
                    }
                    if let servings = recipe.servings {
                        Label("\(servings) порций", systemImage: "person.2")
                    }
                    if let cal = recipe.caloriesPerServing {
                        Label("\(Int(cal)) ккал", systemImage: "flame")
                            .foregroundStyle(.orange)
                    }
                }
                .font(.subheadline)
                
                if let summary = recipe.summary {
                    Text(summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                        .font(.body)
                }
                
                if let ingredients = recipe.extendedIngredients, !ingredients.isEmpty {
                    Text("Ингредиенты")
                        .font(.title2.bold())
                    
                    ForEach(ingredients) { ing in
                        Text("• \(ing.original ?? ing.name)")
                    }
                }
                
                if let steps = recipe.analyzedInstructions?.first?.steps, !steps.isEmpty {
                    Text("Инструкции")
                        .font(.title2.bold())
                    
                    ForEach(steps.indices, id: \.self) { index in
                        let step = steps[index]
                        Text("\(step.number). \(step.step)")
                            .padding(.bottom, 4)
                    }
                }
                
                Button("Добавить в план") {
                    print("Добавлен рецепт: \(recipe.title)")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .navigationTitle("Рецепт")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
