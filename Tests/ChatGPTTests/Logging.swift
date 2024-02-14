//
//  Logging.swift
//  
//
//  Created by Joshua V Sherwood on 2/14/24.
//

import XCTest
@testable import ChatGPT

final class Logging: XCTestCase {

    override func setUpWithError() throws {
       continueAfterFailure = false /// Stop if a failure occurs
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   /**
    Coverage tests, validate basic logging all present (for OS 14.0 and higher)
    */
    func testLogging() throws {
       debug()
       logStack()
       logError("message about error")
       logWarn("message about warning")
    }
}
