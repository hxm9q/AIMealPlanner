import Foundation
import Combine

final class HistoryViewModel: BaseViewModel<Void> {
    
    @Published var plans: [MealPlan] = []
    
    private let plansKey = "savedMealPlans"
    
    override init() {
        super.init()
        loadPlans()
    }
    
    func savePlan(content: String, daysCount: Int, diet: String) {
        let newPlan = MealPlan(
            id: UUID(),
            content: content,
            createdAt: Date(),
            daysCount: daysCount,
            diet: diet
        )
        
        plans.insert(newPlan, at: 0)
        savePlans()
        Logger.log(.info, "План сохранен в историю")
    }
    
    func deletePlan(_ plan: MealPlan) {
        plans.removeAll { $0.id == plan.id }
        savePlans()
        Logger.log(.info, "План удален из истории")
    }
    
    func clearAllPlans() {
        plans.removeAll()
        savePlans()
        Logger.log(.info, "История очищена")
    }
    
    private func loadPlans() {
        if let data = UserDefaults.standard.data(forKey: plansKey),
           let decoded = try? JSONDecoder().decode([MealPlan].self, from: data) {
            plans = decoded
            Logger.log(.info, "Загружено \(plans.count) планов из истории")
        }
    }
    
    private func savePlans() {
        do {
            let data = try JSONEncoder().encode(plans)
            UserDefaults.standard.set(data, forKey: plansKey)
        } catch {
            Logger.log(.error, "Ошибка сохранения планов: \(error)")
        }
    }
    
}
