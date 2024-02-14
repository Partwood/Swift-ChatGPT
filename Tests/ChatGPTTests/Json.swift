//
//  Json.swift
//  
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import XCTest
@testable import ChatGPT

final class Json: XCTestCase {

    override func setUpWithError() throws {
       continueAfterFailure = false /// Stop if a failure occurs
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   /**
    Coverage tests, should cause encoding/decoding failures, but not all (string portion not yet done)
    */
    func testJson() throws {
       enum FooError: Error {
          case failed
       }
       
       class Foo: Codable {
          var name: String
          
          init() {
             name = "Empty"
          }
          
          func encode(to encoder: Encoder) throws {
             throw FooError.failed
          }
       }
       
       if let data = "Abc".data(using: .utf8) {
          _ = jsonDecode(Foo.self,from: data)
       } else {
          XCTFail("Couldn't make data")
       }
       
       let _ = jsonEncode(object: Foo())
    }
}
