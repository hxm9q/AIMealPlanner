import Foundation

struct UserProfile: Codable, Equatable {
    var age: Int = 30
    var weightKg: Double = 75.0
    var heightCm: Double = 175.0
    var gender: Gender = .male
    var goal: Goal = .maintain
    var activityLevel: ActivityLevel = .moderate
    var allergies: [String] = []
    var preferences: [String] = []
    
    enum Gender: String, Codable, CaseIterable {
        case male = "мужской"
        case female = "женский"
    }
    
    enum Goal: String, Codable, CaseIterable {
        case lose = "похудение"
        case maintain = "поддержание"
        case gain = "набор массы"
    }
    
    enum ActivityLevel: String, Codable, CaseIterable {
        case sedentary = "сидячий образ жизни"
        case light = "лёгкая активность"
        case moderate = "средняя активность"
        case active = "высокая активность"
        case veryActive = "очень высокая активность"
    }
}
