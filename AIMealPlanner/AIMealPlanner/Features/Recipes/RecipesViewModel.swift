import Foundation
import Combine

final class RecipesViewModel: BaseViewModel<[Recipe]> {
    
    private let service = SpoonacularService()
    
    @Published var searchText = ""
    @Published var maxCalories: Int = 600
    @Published var selectedDiet: String? = nil
    @Published var selectedCuisine: String? = nil
    @Published var selectedRecipe: Recipe? = nil
    
    let diets = ["", "vegan", "vegetarian", "gluten free", "ketogenic", "paleo"]
    let cuisines = ["", "italian", "mexican", "asian", "mediterranean", "american"]
    
    func search() async {
        viewState = .loading
        
        do {
            let recipes = try await service.searchRecipes(
                query: searchText.isEmpty ? nil : searchText,
                cuisine: selectedCuisine?.isEmpty == false ? selectedCuisine : nil,
                diet: selectedDiet?.isEmpty == false ? selectedDiet : nil,
                maxCalories: maxCalories
            )
            viewState = .loaded(recipes)
        } catch {
            viewState = .error(AppError(from: error))
            Logger.log(.error, "Ошибка поиска: \(error)")
        }
    }
    
    func loadRecipeDetails(id: Int) async {
        do {
            let detailed = try await service.getRecipeDetails(id: id)
            
            if case .loaded(var currentRecipes) = viewState {
                if let index = currentRecipes.firstIndex(where: { $0.id == id }) {
                    currentRecipes[index] = detailed
                    viewState = .loaded(currentRecipes)
                }
            }
            
            selectedRecipe = detailed
            
        } catch {
            Logger.log(.error, "Ошибка загрузки деталей рецепта \(id): \(error)")
        }
    }
    
}
