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
   
   public func toJson() -> String? {
      return jsonEncode(object: self)
   }
   
   public static func fromJson(source: Foundation.Data) -> ChatRequest? {
      return jsonDecode(ChatRequest.self,from: source)
   }
}
