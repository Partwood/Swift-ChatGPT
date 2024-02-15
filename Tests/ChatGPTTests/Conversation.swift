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
             
             let nextRequest = request.merge(validCompletion, followUp: [Message(content: "What time is it in Gary In if it is 8 am in Boston MA?")])
             chat.request(chatRequest: nextRequest, completionHandler: { completion in
                if let validCompletion = completion {
                   validCompletion.choices.forEach({ choice in
                      debug(choice.message.content)
                   })
                } else {
                   XCTFail("Couldn't process result")
                }
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
}
