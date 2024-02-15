//
//  BasicAsync.swift
//  
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import XCTest
@testable import ChatGPT

@available(iOS 13.0.0, *)
final class BasicAsync: XCTestCase {
   var apiKey: String = ""
   
   override func setUpWithError() throws {
      continueAfterFailure = false /// Stop if a failure occurs
   }
   
   override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
   }
   
   /**
    Basic test to show that the user can make a request.
    */
   func testAsyncStructuredConnection() async throws {
      let request = ChatRequest(messages: [Message(content: "Hello, how are you?")])
      
      XCTAssertFalse(apiKey.isEmpty, "When you run this, you need to input your ChatGPT api key")
      
      let chat = ChatGPT.chat(apiKey: apiKey)
      if let completion = await chat.request(chatRequest: request) {
         completion.choices.forEach({ choice in
            debug(choice.message.content)
         })
      } else {
         XCTFail("Couldn't process result")
      }
      
      XCTAssertTrue(true, "Executed")
   }
   
   func testAsyncUnstructuredConnection() async throws {
      XCTAssertFalse(apiKey.isEmpty, "When you run this, you need to input your ChatGPT api key")
      
      let chat = ChatGPT.chat(apiKey: apiKey)
      
      if let completion = await chat.request(message: "If it is 8 am in Boston, MA, what time is it in Gary, In?") {
         completion.choices.forEach({ choice in
            debug(choice.message.content)
         })
      } else {
         XCTFail("Couldn't process result")
      }
      
      XCTAssertTrue(true, "Executed")
   }
}
