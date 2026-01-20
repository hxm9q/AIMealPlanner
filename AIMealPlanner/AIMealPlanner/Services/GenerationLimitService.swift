import Foundation

final class GenerationLimitService {
    static let shared = GenerationLimitService()
    
    private let baseLimitKey       = "baseGenerationsToday"
    private let extraKey           = "extraGenerationsToday"
    private let rewardedCountKey   = "rewardedGenerationsToday"
    private let lastResetKey       = "lastGenerationResetDate"
    
    private let baseDailyLimit     = 3
    private let rewardAmount       = 2
    private let maxRewardsPerDay   = 2
    
    var availableGenerations: Int {
        resetIfNeeded()
        
        let base  = UserDefaults.standard.integer(forKey: baseLimitKey)
        let extra = UserDefaults.standard.integer(forKey: extraKey)
        return max(0, base + extra)
    }
    
    var hasAvailable: Bool {
        availableGenerations > 0
    }
    
    func consumeOne() {
        resetIfNeeded()
        
        var base = UserDefaults.standard.integer(forKey: baseLimitKey)
        if base > 0 {
            base -= 1
            UserDefaults.standard.set(base, forKey: baseLimitKey)
            return
        }
        
        var extra = UserDefaults.standard.integer(forKey: extraKey)
        if extra > 0 {
            extra -= 1
            UserDefaults.standard.set(extra, forKey: extraKey)
        }
    }
    
    func grantReward() {
        resetIfNeeded()
        
        var rewardedToday = UserDefaults.standard.integer(forKey: rewardedCountKey)
        if rewardedToday >= maxRewardsPerDay {
            Logger.log(.warning, "Достигнут дневной лимит rewarded за генерации")
            return
        }
        
        var extra = UserDefaults.standard.integer(forKey: extraKey)
        extra += rewardAmount
        UserDefaults.standard.set(extra, forKey: extraKey)
        
        rewardedToday += 1
        UserDefaults.standard.set(rewardedToday, forKey: rewardedCountKey)
        
        Logger.log(.info, "Выдано +\(rewardAmount) генераций за rewarded (всего extra: \(extra))")
    }
    
    private func resetIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastReset = UserDefaults.standard.object(forKey: lastResetKey) as? Date,
           calendar.isDate(lastReset, inSameDayAs: today) {
            return
        }
        
        UserDefaults.standard.set(baseDailyLimit,    forKey: baseLimitKey)
        UserDefaults.standard.set(0,                 forKey: extraKey)
        UserDefaults.standard.set(0,                 forKey: rewardedCountKey)
        UserDefaults.standard.set(today,             forKey: lastResetKey)
        
        Logger.log(.info, "Лимиты генераций сброшены на новый день")
    }
    
    func debugResetToday() {
        UserDefaults.standard.removeObject(forKey: lastResetKey)
        resetIfNeeded()
    }
    
}
