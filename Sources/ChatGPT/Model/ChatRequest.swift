//
//  ChatRequest.swift
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import Foundation

public struct ChatRequest: Codable, Jsonable {
   var model: String = "gpt-3.5-turbo"
   var messages: [Message]
   var temperature: Float = 0.7 // 1 is the default, lower values are less random
   
   func merge(_ completion: Completion,followUp followUpMessages: [Message]) -> ChatRequest {
      var mergedMessages: [Message] = [Message](self.messages)
      
      completion.choices.forEach({ choice in
         mergedMessages.append(choice.message)
      })
      
      mergedMessages.append(contentsOf: followUpMessages)
      
      return ChatRequest(model: self.model,messages: mergedMessages,temperature: self.temperature)
   }

   func merge(_ completion: Completion,followUp followUpMessages: [String]) -> ChatRequest {
      let newMessages: [Message] = followUpMessages.map({ Message(content: $0) })
      
      return merge(completion, followUp: newMessages)
   }

   public func toJson() -> String? {
      return jsonEncode(object: self)
   }
   
   public static func fromJson(source: Foundation.Data) -> ChatRequest? {
      return jsonDecode(ChatRequest.self,from: source)
   }
}
