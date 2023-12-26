```swift
import XCTest
@testable import YourApp

class AppTests: XCTestCase {
    
    var user: User!
    var authService: AuthenticationService!
    var ocrService: OCRService!
    var gp4Service: GP4Service!
    
    override func setUp() {
        super.setUp()
        user = User.shared
        authService = AuthenticationService.shared
        ocrService = OCRService()
        gp4Service = GP4Service()
    }
    
    override func tearDown() {
        user = nil
        authService = nil
        ocrService = nil
        gp4Service = nil
        super.tearDown()
    }
    
    func testUserSingleton() {
        let user1 = User.shared
        let user2 = User.shared
        XCTAssert(user1 === user2)
    }
    
    func testUserSubscriptionStatus() {
        user.updateSubscriptionStatus(isSubscribed: true)
        XCTAssertTrue(user.isSubscribed)
        user.updateSubscriptionStatus(isSubscribed: false)
        XCTAssertFalse(user.isSubscribed)
    }
    
    func testUserQuestionCount() {
        user.resetQuestionCount()
        XCTAssertEqual(user.questionCount, 0)
        user.incrementQuestionCount()
        XCTAssertEqual(user.questionCount, 1)
    }
    
    func testOCRService() {
        let expectation = self.expectation(description: "OCRService")
        let testImage = UIImage(named: "testImage")!
        
        ocrService.extractText(from: testImage) { (text, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(text)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGP4Service() {
        let expectation = self.expectation(description: "GP4Service")
        
        gp4Service.sendQuestion("What is the capital of France?") { (answer, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(answer)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
```
