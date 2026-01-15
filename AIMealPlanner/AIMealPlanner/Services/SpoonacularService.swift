import Foundation

final class SpoonacularService {
    
    private let apiKey = "838403198b7742a890d839cedc7f7bcc"
    private let baseURL = "https://api.spoonacular.com/recipes"
    
    init() {
        if apiKey.isEmpty {
            print("WARNING: Spoonacular API key is empty!")
        }
    }
    
    func searchRecipes(query: String? = nil,
                       cuisine: String? = nil,
                       diet: String? = nil,
                       maxCalories: Int? = nil,
                       number: Int = 10) async throws -> [Recipe] {
        
        var components = URLComponents(string: "\(baseURL)/complexSearch")!
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "number", value: "\(number)"),
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "fillIngredients", value: "true"),
            URLQueryItem(name: "instructionsRequired", value: "true")
        ]
        
        if let query { queryItems.append(URLQueryItem(name: "query", value: query)) }
        if let cuisine { queryItems.append(URLQueryItem(name: "cuisine", value: cuisine)) }
        if let diet { queryItems.append(URLQueryItem(name: "diet", value: diet)) }
        if let maxCalories { queryItems.append(URLQueryItem(name: "maxCalories", value: "\(maxCalories)")) }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(RecipeSearchResponse.self, from: data)
        
        Logger.log(.info, "Найдено рецептов: \(result.results.count)")
        
        return result.results
    }
    
    func getRecipeDetails(id: Int) async throws -> Recipe {
        let urlString = "\(baseURL)/\(id)/information?apiKey=\(apiKey)&includeNutrition=true"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        return try decoder.decode(Recipe.self, from: data)
    }
    
}
