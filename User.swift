```swift
import Foundation

class User {
    // User properties
    var isSubscribed: Bool {
        didSet {
            UserDefaults.standard.set(isSubscribed, forKey: AppConfig.userDefaultsSubscriptionStatusKey)
        }
    }
    
    var questionCount: Int {
        didSet {
            UserDefaults.standard.set(questionCount, forKey: AppConfig.userDefaultsQuestionCountKey)
        }
    }
    
    // Singleton instance
    static let shared = User()
    
    private init() {
        // Load subscription status from user defaults
        self.isSubscribed = UserDefaults.standard.bool(forKey: AppConfig.userDefaultsSubscriptionStatusKey)
        
        // Load question count from user defaults
        self.questionCount = UserDefaults.standard.integer(forKey: AppConfig.userDefaultsQuestionCountKey)
    }
    
    // Method to increment question count
    func incrementQuestionCount() {
        self.questionCount += 1
    }
    
    // Method to reset question count
    func resetQuestionCount() {
        self.questionCount = 0
    }
    
    // Method to update subscription status
    func updateSubscriptionStatus(isSubscribed: Bool) {
        self.isSubscribed = isSubscribed
    }
}
```
