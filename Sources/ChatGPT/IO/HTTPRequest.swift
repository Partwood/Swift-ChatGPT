//
//  HTTPRequest.swift
//  
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//

import Foundation

class HTTPRequest {
   private var authorization: String
   private var session: URLSession?
   
   init(authorization: String) {
      self.authorization = authorization
   }
   
   /// A method to send post operations as json, which then sends content to the response or error handler as appropriate
   /// - Parameters:
   ///   - url: The string based url, typically https://someurl
   ///   - content: The body to be sent, a json string
   ///   - responseHandler: Called if a valid response and actual data was sent back (doesn't validate the type of data, just that there is data)
   ///   - errorHandler: Called if any error occurred, the response and error are optional
   func postJson(url: String,content: String,responseHandler: @escaping ((_ data: Foundation.Data)->Void),errorHandler: @escaping((_ response: URLResponse?,_ error: Error?)->Void)) {
      if let constructedUrl = URL(string: "https://api.openai.com/v1/chat/completions") {
         postJson(url: constructedUrl,content: content,handler: { (response: URLResponse?,data: Foundation.Data) in
            // Got a response
            responseHandler(data)
         },errorHandler: { (response: URLResponse?,error: Error?) in
            // Got an error
            errorHandler(response,error)
         })
      }
   }
   
   private func getJson(url: URL,handler: @escaping ((_ response:URLResponse?,_ data:Foundation.Data)->Void),errorHandler: @escaping ((_ response:URLResponse?, _ error:Error?)->Void)) {
      debug("url:"+url.debugDescription)
      
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue(authorization, forHTTPHeaderField: "Authorization")
      
      if let validatedSession = getSession() {
         let task = validatedSession.dataTask(with: request as URLRequest) {
            data, response, error in
            self.handleResponse(handler: handler,errorHandler: errorHandler,data,response,error)
         }
         task.resume()
      }
   }

   private func postJson(url: URL,content: String,handler: @escaping ((_ response:URLResponse?,_ data:Foundation.Data)->Void),errorHandler: @escaping ((_ response:URLResponse?, _ error:Error?)->Void)) {
      debug("url:"+url.debugDescription)
      
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.httpBody = content.data(using: String.Encoding.utf8)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue(authorization, forHTTPHeaderField: "Authorization")
      
      if let validatedSession = getSession() {
         let task = validatedSession.dataTask(with: request as URLRequest) {
            data, response, error in
            self.handleResponse(handler: handler,errorHandler: errorHandler,data,response,error)
         }
         task.resume()
      }
   }

   private func getConfig() -> URLSessionConfiguration? {
      return  URLSessionConfiguration.default
   }
   
   private func getSession() -> URLSession? {
      if ( self.session == nil ) {
         if let validatedConfig = getConfig() {
            self.session = URLSession(configuration: validatedConfig, delegate: nil, delegateQueue: nil)
         }
      }
      return self.session
   }
   
   private func handleResponse(handler: @escaping ((_ response:URLResponse?,_ data:Foundation.Data)->Void),errorHandler: @escaping ((_ response:URLResponse?, _ error:Error?)->Void),_ data:Foundation.Data?, _ response:URLResponse?, _ error:Error?) {
      if let validatedResponse:HTTPURLResponse = response as? HTTPURLResponse {
         if (200...299).contains(validatedResponse.statusCode) {
            // Valid
            debug("Valid response statusCode:\(validatedResponse.statusCode)")
         } else {
            // Bad response
            logWarn("statusCode:\(validatedResponse.statusCode)")
            logWarn("validatedResponse:\(validatedResponse)")
            errorHandler(response, error)
            return
         }
      } else {
         logWarn("No HTTPURLResponse")
      }
      
      guard let validatedData = data else {
         logWarn("Valid response, but no data. Treating as error")
         errorHandler(response, error)
         return
      }
      
      handler(response,validatedData)
   }
}

/// Async
@available(iOS 13.0.0, *)
extension HTTPRequest {
   func postJson(url: String,content: String) async -> (data: Foundation.Data?,response: URLResponse?,error: Error?) {
      if let constructedUrl = URL(string: "https://api.openai.com/v1/chat/completions") {
         let result = await postJson(url: constructedUrl,content: content)
         return result
      }
      
      logError("Invalid url")
      return (nil, nil, nil)
   }

   private func postJson(url: URL,content: String) async -> (data: Foundation.Data?,response: URLResponse?,error: Error?) {
      debug("url:"+url.debugDescription)
      
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.httpBody = content.data(using: String.Encoding.utf8)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue(authorization, forHTTPHeaderField: "Authorization")
      
      if let validatedSession = getSession() {
         do {
            let response = try await validatedSession.data(for: request)
            return handleResponse(response.0, response.1)
         } catch {
            logError(error)
            return (nil, nil, error)
         }
      }
      
      logError("No session")
      return (nil, nil, nil)
   }

   private func handleResponse(_ data: Foundation.Data,_ response: URLResponse) -> (data: Foundation.Data?,response: URLResponse?,error: Error?) {
      if let validatedResponse:HTTPURLResponse = response as? HTTPURLResponse {
         if (200...299).contains(validatedResponse.statusCode) {
            // Valid
            debug("Valid response statusCode:\(validatedResponse.statusCode)")
         } else {
            // Bad response
            logWarn("statusCode:\(validatedResponse.statusCode)")
            logWarn("validatedResponse:\(validatedResponse)")
            return (nil, response, nil)
         }
      } else {
         logWarn("No HTTPURLResponse")
      }
      
      return (data, response, nil)
   }
}
