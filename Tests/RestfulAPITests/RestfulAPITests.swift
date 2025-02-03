import XCTest
@testable import RestfulAPI

final class RestfulAPITests: XCTestCase {
    struct Example: Codable {
        let userId: Int
        let id: Int
        let title: String
        
    }
    
    var sut: RestfulAPI<EMPTYMODEL,Example>!
    
    override func setUp() {
        super.setUp()
        //      sut = RestfulAPI<EMPTYMODEL,Example>(path: "https://jsonplaceholder.typicode.com/todos/1")
    }
    
    // Provides an opportunity to perform cleanup after each test method in a test case ends.
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let promise = expectation(description: "Completion handler invoked")
        sut.sendURLSessionRequest { (response) in
            switch response {
            case .success(_):
                promise.fulfill()
            default:
                XCTFail("Status code")
                break
            }
        }
        self.waitForExpectations(timeout: 4)
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
