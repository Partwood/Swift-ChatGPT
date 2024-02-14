//
//  Message.swift
//
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import Foundation

public struct Message: Codable {
   var role: String = "user"
   var content: String
   
   func toJson() -> String? {
      return jsonEncode(object: self)
   }
   
   static func fromJson(source: Foundation.Data) -> Message? {
      return jsonDecode(Message.self,from: source)
   }
}
