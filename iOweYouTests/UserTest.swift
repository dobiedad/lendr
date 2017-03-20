import XCTest

@testable import iOweYou

class UserTest: XCTestCase {
    
    func testInitWithUser() {
        let exp = expectation(description: "Loaded Product From Data")
        let name = "Leo the testa";
        let builder = UserBuilder(name:name)
        let user = builder.buildUser()
        exp.fulfill()
        
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error, "Error")
            XCTAssertEqual(user.name, name)
        }
    }
}
