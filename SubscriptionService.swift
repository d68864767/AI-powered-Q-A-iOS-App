```swift
import Foundation
import StoreKit

class SubscriptionService: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    // Singleton instance
    static let shared = SubscriptionService()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    // Method to request product info from App Store
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productID = NSSet(object: AppConfig.subscriptionProductId)
            let productsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
        } else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    // SKProductsRequestDelegate method
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            buyProduct(product)
        } else {
            print("Product not found")
        }
    }
    
    // Method to buy a product
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // SKPaymentTransactionObserver methods
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                User.shared.updateSubscriptionStatus(isSubscribed: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed, .restored:
                User.shared.updateSubscriptionStatus(isSubscribed: false)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    // Method to restore purchases
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
```
