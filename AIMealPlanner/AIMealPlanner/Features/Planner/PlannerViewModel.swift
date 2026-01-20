import Foundation
import Combine

final class PlannerViewModel: BaseViewModel<Void> {
    
    @Published var daysCount: Int = 1
    @Published var diet: String = ""
    @Published var generatedPlan: String? = nil
    @Published var isGenerating = false
    @Published var errorMessage: String? = nil
    
    private let service = GroqService()
    
    var canGenerate: Bool {
        GenerationLimitService.shared.hasAvailable
    }
    
    var remainingGenerations: Int {
        GenerationLimitService.shared.availableGenerations
    }
    
    func generatePlan(profile: UserProfile) async {
        guard GenerationLimitService.shared.hasAvailable else {
            errorMessage = "Достигнут дневной лимит генераций. Получите дополнительные за просмотр рекламы."
            return
        }
        
        isGenerating = true
        errorMessage = nil
        generatedPlan = nil
        
        let prompt = """
        Составь подробный план питания на \(daysCount) день(дней) для человека со следующими параметрами:
        Возраст: \(profile.age) лет
        Пол: \(profile.gender.rawValue)
        Вес: \(profile.weightKg) кг
        Рост: \(profile.heightCm) см
        Цель: \(profile.goal.rawValue)
        Уровень активности: \(profile.activityLevel.rawValue)
        Предпочтения: \(profile.preferences.joined(separator: ", "))
        Исключить: \(profile.allergies.joined(separator: ", "))
        Диета: \(diet.isEmpty ? "без ограничений" : diet)
        
        Для каждого дня укажи:
        - Завтрак
        - Перекус 1
        - Обед
        - Перекус 2
        - Ужин
        
        Примерные калории и макросы (Б/Ж/У) для каждого приёма пищи.
        Общая суточная калорийность должна быть примерно 2500–2800 ккал (или адаптируй под цель).
        Сделай меню разнообразным, вкусным и реалистичным.
        Отвечай только на русском языке.
        """
        
        do {
            let response = try await service.generateMealPlan(prompt: prompt)
            let cleanedPlan = response
                .replacingOccurrences(of: "#", with: "")
                .replacingOccurrences(of: "*", with: "")
                .replacingOccurrences(of: "-", with: "• ")
                .replacingOccurrences(of: "\n\n", with: "\n")
            
            let todayPlan = MealPlan(
                id: UUID(),
                content: cleanedPlan,
                createdAt: Date(),
                daysCount: daysCount,
                diet: diet
            )
            
            if let data = try? JSONEncoder().encode(todayPlan) {
                UserDefaults.standard.set(data, forKey: "todayPlan")
                UserDefaults.standard.set(true, forKey: "hasTodayPlan")
                Logger.log(.info, "Сегодняшний план сохранён")
            }
            
            GenerationLimitService.shared.consumeOne()
            
            generatedPlan = cleanedPlan.trimmingCharacters(in: .whitespacesAndNewlines)
            Logger.log(.info, "План сгенерирован, длина: \(response.count)")
            
            AnalyticsService.shared.logMealPlanGenerated(
                daysCount: daysCount,
                diet: diet,
                planLengthChars: cleanedPlan.count,
                profile: profile
            )
        } catch {
            errorMessage = "Ошибка генерации: \(error.localizedDescription)"
            Logger.log(.error, "Ошибка Groq: \(error)")
            
            AnalyticsService.shared.logMealPlanFailed(
                error: error,
                daysCount: daysCount,
                diet: diet
            )
        }
        
        isGenerating = false
    }
    
}
