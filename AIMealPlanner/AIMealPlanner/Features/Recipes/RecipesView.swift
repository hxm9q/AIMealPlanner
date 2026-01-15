import SwiftUI

struct RecipesView: View {
    
    @StateObject private var viewModel = RecipesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Поиск (например, chicken curry)", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                HStack {
                    Picker("Диета", selection: $viewModel.selectedDiet) {
                        ForEach(viewModel.diets, id: \.self) { diet in
                            Text(diet.isEmpty ? "Все" : diet.capitalized).tag(diet)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Кухня", selection: $viewModel.selectedCuisine) {
                        ForEach(viewModel.cuisines, id: \.self) { cuisine in
                            Text(cuisine.isEmpty ? "Все" : cuisine.capitalized).tag(cuisine)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding(.horizontal)
                
                Stepper("Макс. калорий на порцию: \(viewModel.maxCalories)",
                        value: $viewModel.maxCalories, in: 200...1200, step: 50)
                    .padding(.horizontal)
                
                Button("Найти рецепты") {
                    Task { await viewModel.search() }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                content
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $viewModel.selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.viewState {
        case .idle:
            VStack {
                Spacer()
                Text("Введите запрос или выберите фильтры и нажмите «Найти»")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            
        case .loading:
            LoadingView()
            
        case .loaded(let recipes):
            if recipes.isEmpty {
                Text("Рецепты не найдены\nПопробуйте изменить фильтры")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            } else {
                List(recipes) { recipe in
                    RecipeCard(recipe: recipe)
                        .onTapGesture {
                            Task {
                                if recipe.extendedIngredients == nil {
                                    await viewModel.loadRecipeDetails(id: recipe.id)
                                } else {
                                    viewModel.selectedRecipe = recipe
                                }
                            }
                        }
                }
                .listStyle(.plain)
            }
            
        case .error(let error):
            ErrorView(error: error) {
                Task { await viewModel.search() }
            }
        }
    }
    
}
