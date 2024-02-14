//
//  Usage.swift
//  
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import Foundation

public struct Usage: Codable {
   var completion_tokens: Int // Number of tokens in the generated completion.
   var prompt_tokens: Int // Number of tokens in the prompt.
   var total_tokens: Int // Total number of tokens used in the request (prompt + completion).
}
