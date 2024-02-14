//
//  Completion.swift
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import Foundation

public struct Completion: Codable {
   var id: String // A unique identifier for the chat completion.
   var choices: [Choice]
   var created: Int // The Unix timestamp (in seconds) of when the chat completion was created.
   var model: String
   var system_fingerprint: String?
   var object: String
   var usage: Usage
}
