//
//  Choice.swift
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import Foundation

public struct Choice: Codable {
   var finish_reason: String
   var index: Int
   var message: Message
}
