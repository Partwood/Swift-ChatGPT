//
//  Logging.swift
//
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import Foundation
import os

/**
 NOTE If using this on the console, you should turn on info/debug via action dialog in the console product. 
 ALSO, you can filter by subsystem 'Partwood.ChatGPT' and category 'product'
 */

func logStack(whichFile:String = #file,whichFunction:String = #function,whichLine:Int = #line) {
   var errorStack = String()
   Thread.callStackSymbols.forEach {
      if ( !$0.contains("logStack") ) {
         errorStack = "\(errorStack)\n" + $0
      }
   }
   
   logError(prefix: "STACK ",message: errorStack, file:whichFile, function:whichFunction, line:whichLine)
}

func logError(_ error:Error,whichFile:String = #file,whichFunction:String = #function,whichLine:Int = #line) {
   let message = "\(error)"
   logError(message: message, file:whichFile, function:whichFunction, line:whichLine)
}

func logError(_ message:String,whichFile:String = #file,whichFunction:String = #function,whichLine:Int = #line) {
   logError(message: message, file:whichFile, function:whichFunction, line:whichLine)
}

func logWarn(_ message:String,whichFile:String = #file,whichFunction:String = #function,whichLine:Int = #line) {
   logError(prefix: "WARN ",message: message, file:whichFile, function:whichFunction, line:whichLine)
}

private func logError(prefix: String = "ERROR ",message: String,file: String,function: String,line: Int) {
   let fileName = file.suffix(from:file.lastIndex(of: "/")!)
   
   if #available(iOS 14.0, *) {
      Logger.chatGPTLog.error("\(prefix, privacy: .public)\(fileName, privacy: .public)::\(function, privacy: .public)[\(line, privacy: .public)] \(message, privacy: .public)")
   } else {
      // Fallback on earlier versions
      debugRaw("\(prefix)\(fileName)::\(function)[\(line)] \(message)")
   }
}

#if DEBUG
func debug(whichFile:String = #file,whichFunction:String = #function,whichLine:Int = #line) {
   let fileName = whichFile.suffix(from:whichFile.lastIndex(of: "/")!)
   if #available(iOS 14.0, *) {
      Logger.chatGPTLog.log("DEBUG \(fileName, privacy: .public)::\(whichFunction, privacy: .public)[\(whichLine, privacy: .public)]")
   } else {
      // Fallback on earlier versions
      let message = "DEBUG \(fileName)::\(whichFunction)[\(whichLine)]"
      debugRaw(message)
   }
}

func debug(_ message:String,whichFile:String = #file,whichFunction:String = #function,whichLine:Int = #line) {
   let fileName = whichFile.suffix(from:whichFile.lastIndex(of: "/")!)
   if #available(iOS 14.0, *) {
      Logger.chatGPTLog.log("DEBUG \(fileName, privacy: .public)::\(whichFunction, privacy: .public)[\(whichLine, privacy: .public)] \(message, privacy: .public)")
   } else {
      // Fallback on earlier versions
      let message = "DEBUG \(fileName)::\(whichFunction)[\(whichLine)] \(message)"
      debugRaw(message)
   }
}

func debugRaw(_ message:String) {
   print(message)
}
#else
func debugRaw(_ message:String) {}
func debug(whichFile:String = #file,whichFunction:String = #function,whichLine:Int = #line) {}
func debug(_ message:String,whichFile:String = #file,whichFunction:String = #function,whichLine:Int = #line) {}
func debugPrint(items: Any..., separator: String = " ", terminator: String = "\n") {}
//func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {}
//func print(items: Any..., separator: String = " ", terminator: String = "\n") {}
#endif

@available(iOS 14.0, *)
extension Logger {
   private static var subsystem = Bundle.main.bundleIdentifier!
   
   /// Logs the view cycles like viewDidLoad.
   /// The logger levels do not work universally, that is the console and debug system do not reliable log different levels.
   static let chatGPTLog = Logger(subsystem: subsystem, category: "chatgpt")
}
