import Foundation

struct MealPlan: Identifiable, Codable, Equatable {
    let id: UUID
    let content: String
    let createdAt: Date
    let daysCount: Int
    let diet: String
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: createdAt)
    }
    
    var dietLabel: String {
        switch diet {
        case "vegetarian": return "Вегетарианская"
        case "vegan": return "Веганская"
        case "keto": return "Кето"
        default: return "Без ограничений"
        }
    }
    
    var shortPreview: String {
        let lines = content.components(separatedBy: .newlines)
        return lines.prefix(5).joined(separator: "\n") + (lines.count > 5 ? "..." : "")
    }
}
