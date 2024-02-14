//
//  Json.swift
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import Foundation

public protocol Jsonable {
   func toJson() -> String?
   static func fromJson(source: Foundation.Data) -> ChatRequest?
}

func jsonDecode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
   do {
      let result = try JSONDecoder().decode(T.self, from: data)
      return result
   } catch {
      logError(error)
      
      if let stringValue = String(data: data, encoding: .utf8) {
         logError(stringValue)
      }
      
      return nil
   }
}

func jsonEncode<T: Encodable>(object: T) -> String? {
   if let encodedData:Data = try? JSONEncoder().encode(object) {
      if let stringValue = String(data: encodedData, encoding: .utf8) {
         return stringValue
      } else {
         logError("Failed to create string")
         return nil
      }
   } else {
      logError("Failed to encode content")
      return nil
   }
}
