import Foundation
import Combine

final class HomeViewModel: BaseViewModel<Void> {
    
    @Published var userProfile: UserProfile = UserProfile()
    @Published var dailyCalories: Int = 0
    @Published var hasTodayPlan: Bool = false
    @Published var todayPlan: MealPlan? = nil
    
    private let profileKey = "userProfile"
    
    override init() {
        super.init()
        loadProfile()
    }
    
    func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = profile
            calculateDailyCalories()
            Logger.log(.info, "Профиль загружен из UserDefaults")
        } else {
            Logger.log(.info, "Профиль не найден — дефолтные значения")
        }
    }
    
    func saveProfile() {
        do {
            let data = try JSONEncoder().encode(userProfile)
            UserDefaults.standard.set(data, forKey: profileKey)
            calculateDailyCalories()
            Logger.log(.info, "Профиль сохранён")
        } catch {
            Logger.log(.error, "Ошибка сохранения профиля: \(error)")
        }
    }
    
    func calculateDailyCalories() {
        let bmr: Double
        
        switch userProfile.gender {
        case .male:
            bmr = 88.362 + (13.397 * userProfile.weightKg) + (4.799 * userProfile.heightCm) - (5.677 * Double(userProfile.age))
        case .female:
            bmr = 447.593 + (9.247 * userProfile.weightKg) + (3.098 * userProfile.heightCm) - (4.330 * Double(userProfile.age))
        }
        
        let activityMultiplier: Double = switch userProfile.activityLevel {
        case .sedentary: 1.2
        case .light: 1.375
        case .moderate: 1.55
        case .active: 1.725
        case .veryActive: 1.9
        }
        
        var calories = Int(bmr * activityMultiplier)
        
        switch userProfile.goal {
        case .lose: calories -= 500
        case .gain: calories += 500
        case .maintain: break
        }
        
        dailyCalories = max(1200, calories)
    }
    
}
