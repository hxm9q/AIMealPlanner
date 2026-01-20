import Foundation

final class GroqService {
    
    private let apiKey = Secrets.groq.rawValue
    
    private let baseURL = "https://api.groq.com/openai/v1/chat/completions"
    
    func generateMealPlan(prompt: String) async throws -> String {
        guard !apiKey.isEmpty else {
            throw NSError(domain: "Groq", code: -1, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])
        }
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "model": "llama-3.3-70b-versatile",
            "messages": [
                ["role": "system", "content": "Ты эксперт по питанию. Отвечай только на русском языке. Генерируй чёткие, структурированные планы питания без лишней воды. Используй markdown для форматирования (заголовки, списки, жирный текст)."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 2048,
            "stream": false
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let errorText = String(data: data, encoding: .utf8) ?? "No response body"
            Logger.log(.error, "Groq вернул ошибку. Код: \(statusCode). Тело: \(errorText)")
            throw NSError(domain: "Groq", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(statusCode)"])
        }
        
        let json = try JSONDecoder().decode(GroqResponse.self, from: data)
        guard let content = json.choices.first?.message.content else {
            throw NSError(domain: "Groq", code: -2, userInfo: [NSLocalizedDescriptionKey: "No content in response"])
        }
        
        Logger.log(.info, "Groq вернул план длиной \(content.count) символов")
        return content
    }
    
}

struct GroqResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
