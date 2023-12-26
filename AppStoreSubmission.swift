```swift
import Foundation
import StoreKit

class AppStoreSubmissionService {
    
    // Singleton instance
    static let shared = AppStoreSubmissionService()
    
    private init() {}
    
    // Method to request a product from the App Store
    func requestProduct(productId: String, completion: @escaping (SKProduct?, Error?) -> Void) {
        let productIdentifiers = Set(arrayLiteral: productId)
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    // Method to purchase a product
    func purchaseProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // Method to restore purchases
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate
extension AppStoreSubmissionService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            print("Product not found")
            return
        }
        
        // Notify the app that the product has been received
        NotificationCenter.default.post(name: .productReceived, object: product)
    }
}

// MARK: - SKPaymentTransactionObserver
extension AppStoreSubmissionService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Handle successful purchase
                User.shared.updateSubscriptionStatus(isSubscribed: true)
                User.shared.resetQuestionCount()
                queue.finishTransaction(transaction)
            case .restored:
                // Handle successful restore
                User.shared.updateSubscriptionStatus(isSubscribed: true)
                queue.finishTransaction(transaction)
            case .failed:
                // Handle failed transaction
                queue.finishTransaction(transaction)
            default:
                break
            }
        }
    }
}

// MARK: - Notification.Name Extension
extension Notification.Name {
    static let productReceived = Notification.Name("productReceived")
}
```
