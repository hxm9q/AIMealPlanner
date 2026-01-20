import Foundation
import FirebaseAnalytics
import AppMetricaCore
import AppsFlyerLib

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    private init() {}
    
    func logMealPlanGenerateRequested(
        daysCount: Int,
        diet: String,
        profile: UserProfile
    ) {
        let dietValue = diet.isEmpty ? "any" : diet
        
        let commonParams: [String: Any] = [
            "days_count": daysCount,
            "diet": dietValue,
            "age": profile.age,
            "weight_kg": profile.weightKg,
            "height_cm": profile.heightCm,
            "goal": profile.goal.rawValue,
            "activity_level": profile.activityLevel.rawValue
        ]
        
        // AppMetrica
        AppMetrica.reportEvent(name: "meal_plan_generate_requested", parameters: commonParams)
        
        // AppsFlyer
        let afParams: [String: Any] = [
            "af_days_count": daysCount,
            "af_diet": dietValue,
            "af_user_goal": profile.goal.rawValue
        ]
        AppsFlyerLib.shared().logEvent("af_generate_plan_clicked", withValues: afParams)
        
        // Firebase
        Analytics.logEvent("meal_plan_generate_requested", parameters: commonParams as? [String: NSObject])
    }
    
    func logMealPlanSaved(
        daysCount: Int,
        diet: String,
        planLengthChars: Int,
        hasTodayPlan: Bool
    ) {
        let dietValue = diet.isEmpty ? "any" : diet
        
        let params: [String: Any] = [
            "days_count": daysCount,
            "diet": dietValue,
            "plan_length_chars": planLengthChars,
            "has_today_plan": hasTodayPlan
        ]
        
        // AppMetrica
        AppMetrica.reportEvent(name: "meal_plan_saved", parameters: params)
        
        // AppsFlyer
        AppsFlyerLib.shared().logEvent("af_meal_plan_saved", withValues: params.mapKeys { "af_" + $0 } )
        
        // Firebase
        Analytics.logEvent("meal_plan_saved", parameters: params as? [String: NSObject])
    }
    
    func logMealPlanGenerated(
        daysCount: Int,
        diet: String,
        planLengthChars: Int,
        profile: UserProfile
    ) {
        let dietValue = diet.isEmpty ? "any" : diet
        
        let commonParams: [String: Any] = [
            "days_count": daysCount,
            "diet": dietValue,
            "plan_length_chars": planLengthChars,
            "age": profile.age,
            "weight_kg": profile.weightKg,
            "height_cm": profile.heightCm,
            "goal": profile.goal.rawValue,
            "activity_level": profile.activityLevel.rawValue
        ]
        
        // AppMetrica
        AppMetrica.reportEvent(name: "meal_plan_generated_success", parameters: commonParams)
        
        // AppsFlyer
        let afParams = commonParams.mapKeys { "af_" + $0 }
        AppsFlyerLib.shared().logEvent("af_meal_plan_generated", withValues: afParams)
        
        // Firebase
        Analytics.logEvent("meal_plan_generated_success", parameters: commonParams as? [String: NSObject])
    }
    
    func logMealPlanFailed(
        error: Error,
        daysCount: Int,
        diet: String
    ) {
        let dietValue = diet.isEmpty ? "any" : diet
        
        let commonParams: [String: Any] = [
            "error_message": error.localizedDescription,
            "error_type": String(describing: type(of: error)),
            "days_count": daysCount,
            "diet": dietValue
        ]
        
        // AppMetrica
        AppMetrica.reportEvent(name: "meal_plan_generate_failed", parameters: commonParams)
        
        // AppsFlyer
        let afParams = commonParams.mapKeys { "af_" + $0 }
        AppsFlyerLib.shared().logEvent("af_meal_plan_error", withValues: afParams)
        
        // Firebase
        Analytics.logEvent("meal_plan_generate_failed", parameters: commonParams as? [String: NSObject])
    }
    
    func logRecipesSearchRequested(
        searchText: String,
        diet: String?,
        cuisine: String?,
        maxCalories: Int
    ) {
        let params: [String: Any] = [
            "search_text": searchText.isEmpty ? "(empty)" : searchText,
            "diet": diet ?? "(any)",
            "cuisine": cuisine ?? "(any)",
            "max_calories": maxCalories
        ]
        
        // AppMetrica
        AppMetrica.reportEvent(name: "recipes_search_requested", parameters: params)
        
        // AppsFlyer
        AppsFlyerLib.shared().logEvent(
            "af_recipes_search_clicked",
            withValues: [
                "af_has_query": !searchText.isEmpty,
                "af_diet": diet ?? "any",
                "af_cuisine": cuisine ?? "any"
            ]
        )
        
        // Firebase
        Analytics.logEvent("recipes_search_requested", parameters: params as? [String: NSObject])
    }
    
    func logRecipesSearchSuccess(
        recipesCount: Int,
        searchText: String,
        diet: String?,
        cuisine: String?,
        maxCalories: Int
    ) {
        let params: [String: Any] = [
            "recipes_found": recipesCount,
            "search_text": searchText.isEmpty ? "(empty)" : searchText,
            "diet": diet ?? "(any)",
            "cuisine": cuisine ?? "(any)",
            "max_calories": maxCalories
        ]
        
        // AppMetrica
        AppMetrica.reportEvent(name: "recipes_search_success", parameters: params)
        
        // AppsFlyer
        AppsFlyerLib.shared().logEvent(
            "af_recipes_search",
            withValues: [
                "af_results_count": recipesCount,
                "af_has_query": !searchText.isEmpty,
                "af_diet_filter": diet ?? "any",
                "af_cuisine_filter": cuisine ?? "any",
                "af_max_calories": maxCalories
            ]
        )
        
        // Firebase
        Analytics.logEvent("recipes_search_success", parameters: params as? [String: NSObject])
    }
    
}

extension Dictionary {
    
    func mapKeys<NewKey>(_ transform: (Key) throws -> NewKey) rethrows -> [NewKey: Value] {
        try .init(
            uniqueKeysWithValues: map { key, value in
                (try transform(key), value)
            }
        )
    }
    
}
