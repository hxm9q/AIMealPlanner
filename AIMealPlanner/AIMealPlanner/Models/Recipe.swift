import Foundation

struct RecipeSearchResponse: Codable {
    let results: [Recipe]
    let totalResults: Int
    let offset: Int
    let number: Int
}

struct Recipe: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let image: String?
    let imageType: String?
    let readyInMinutes: Int?
    let servings: Int?
    let sourceUrl: String?
    let spoonacularScore: Double?
    let healthScore: Double?
    let pricePerServing: Double?
    
    var extendedIngredients: [Ingredient]?
    var analyzedInstructions: [Instruction]?
    var summary: String?
    var instructions: String?
    var nutrition: Nutrition?
    
    var caloriesPerServing: Double? {
        nutrition?.nutrients.first(where: { $0.name == "Calories" })?.amount
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Ingredient: Codable, Identifiable {
    let id: Int?
    let name: String
    let amount: Double?
    let unit: String?
    let original: String?
    
    var idOrHash: Int { id ?? original?.hashValue ?? 0 }
}

struct Instruction: Codable {
    let name: String?
    let steps: [Step]?
}

struct Step: Codable {
    let number: Int
    let step: String
}

struct Nutrition: Codable {
    let nutrients: [Nutrient]
}

struct Nutrient: Codable {
    let name: String
    let amount: Double
    let unit: String
}

struct IngredientReference: Codable {
    let id: Int?
    let name: String
    let localizedName: String?
    let image: String?
}

struct Equipment: Codable {
    let id: Int?
    let name: String
    let localizedName: String?
    let image: String?
}

struct Length: Codable {
    let number: Int
    let unit: String
}
