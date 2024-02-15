//
//  Conversation.swift
//
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import XCTest
@testable import ChatGPT

final class Conversation: XCTestCase {
   var apiKey: String = ""
   var invalidApiKey: String = "sk"

    override func setUpWithError() throws {
       continueAfterFailure = false /// Stop if a failure occurs
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStructuredConnection() throws {
    }
   
   func testUnstructuredConnection() throws {
   }
}
