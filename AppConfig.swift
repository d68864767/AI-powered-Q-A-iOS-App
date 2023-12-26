```swift
import Foundation

struct AppConfig {
    // API keys
    static let gpt4ApiKey = "YOUR_GPT4_API_KEY"
    static let ocrApiKey = "YOUR_OCR_API_KEY"
    
    // Base URLs
    static let gpt4BaseUrl = "https://api.openai.com/v4/"
    static let ocrBaseUrl = "https://api.ocr.space/parse/image"
    
    // Other constants
    static let maxFreeQuestions = 10
    static let subscriptionPrice = 4.99
    static let subscriptionProductId = "com.yourcompany.yourapp.subscription"
    
    // User defaults keys
    static let userDefaultsQuestionCountKey = "questionCount"
    static let userDefaultsSubscriptionStatusKey = "isSubscribed"
}
```
