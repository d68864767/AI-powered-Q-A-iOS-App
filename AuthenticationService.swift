```swift
import Foundation
import FirebaseAuth

class AuthenticationService {
    // Singleton instance
    static let shared = AuthenticationService()
    
    private init() {}
    
    // Method to sign up a new user
    func signUp(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(false, error)
            } else {
                // Set initial values for the new user
                User.shared.updateSubscriptionStatus(isSubscribed: false)
                User.shared.resetQuestionCount()
                completion(true, nil)
            }
        }
    }
    
    // Method to log in a user
    func logIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    // Method to log out a user
    func logOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    // Method to check if a user is logged in
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // Method to get the current user's email
    func currentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
}
```
