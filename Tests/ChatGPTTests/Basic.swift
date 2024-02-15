//
//  Basic.swift
//  
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import XCTest
@testable import ChatGPT

final class Basic: XCTestCase {
   var apiKey: String = ""
   var invalidApiKey: String = "sk"

    override func setUpWithError() throws {
       continueAfterFailure = false /// Stop if a failure occurs
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   /**
    Basic test to show that the user can make a request.
    */
    func testStructuredConnection() throws {
       let request = ChatRequest(messages: [Message(content: "Hello, how are you?")])

       var waitOnResponse: Bool = false
       
       XCTAssertFalse(apiKey.isEmpty, "When you run this, you need to input your ChatGPT api key")
       
       let chat = ChatGPT.chat(apiKey: apiKey, organization: "organization")
       
       waitOnResponse = true
       chat.request(chatRequest: request,completionHandler: { completion in
          XCTAssertNotNil(completion)
          
          if let validCompletion = completion {
             validCompletion.choices.forEach({ choice in
                debug(choice.message.content)
             })
          } else {
             XCTFail("Couldn't process result")
          }
          
          waitOnResponse = false
       })

       while (waitOnResponse) {
          debug("Sleep")
          Thread.sleep(forTimeInterval: 5)
       }
       
       XCTAssertTrue(true, "Executed")
    }
   
   func testUnstructuredConnection() throws {
      var waitOnResponse: Bool = false
      
      XCTAssertFalse(apiKey.isEmpty, "When you run this, you need to input your ChatGPT api key")
      
      let chat = ChatGPT.chat(apiKey: apiKey, organization: "organization")
      
      waitOnResponse = true
      chat.request(message: "If it is 8 am in Boston, MA, what time is it in Gary, In?",completionHandler: { completion in
         XCTAssertNotNil(completion)
         if let result = completion {
            debug("\(result)")
         } else {
            XCTFail("Couldn't process result")
         }
         waitOnResponse = false
      })
      
      while (waitOnResponse) {
         debug("Sleep")
         Thread.sleep(forTimeInterval: 5)
      }
      
      XCTAssertTrue(true, "Executed")
   }
   
   func testFailUnstructuredConnection() throws {
      var waitOnResponse: Bool = false
      
      XCTAssertFalse(invalidApiKey.isEmpty, "When you run this, you need to input a bad ChatGPT api key")
      
      let chat = ChatGPT.chat(apiKey: invalidApiKey, organization: "organization")
      
      waitOnResponse = true
      chat.request(message: "What time is it?",completionHandler: { completion in
         XCTAssertNil(completion)
         waitOnResponse = false
      })
      
      while (waitOnResponse) {
         debug("Sleep")
         Thread.sleep(forTimeInterval: 5)
      }
      
      XCTAssertTrue(true, "Executed")
   }
   
   func testFailJsonConnection() throws {
      enum JsonableError: Error {
         case failed
      }
      
      class BadJsonable: Jsonable {
         func toJson() -> String? {
            return nil
         }
         static func fromJson(source: Foundation.Data) -> ChatRequest? {
            return nil
         }
      }

      var waitOnResponse: Bool = false
      
      XCTAssertFalse(apiKey.isEmpty, "When you run this, you need to input a bad ChatGPT api key")
      
      let chat = ChatGPT.chat(apiKey: apiKey, organization: "organization")
      
      waitOnResponse = true
      chat.request(chatRequest: BadJsonable(),completionHandler: { completion in
         XCTAssertNil(completion)
         waitOnResponse = false
      })
      
      while (waitOnResponse) {
         debug("Sleep")
         Thread.sleep(forTimeInterval: 5)
      }
      
      XCTAssertTrue(true, "Executed")
   }
}
