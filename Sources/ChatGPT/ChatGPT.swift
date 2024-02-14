//
//  ChatGPT
//
//  Copyright © 2024 JVSherwood. All rights reserved.
//
public struct ChatGPT {
   struct chat {
      private var apiKey: String
      private var organization: String?
      private static let completionURL = "https://api.openai.com/v1/chat/completions"
      
      /// Constructor
      /// - Parameters:
      ///   - apiKey: Your ChatGPT apikey
      ///   - organization: Your organization, optional and if present is sent in requests
      public init(apiKey: String,organization: String? = nil) {
         self.apiKey = apiKey
         self.organization = organization
      }
      
      /// Make a request to ChatGPT completions
      /// - Parameters:
      ///   - raw: The raw string request to be sent
      ///   - responseHandler: Called on any progress, which may have a null completion object
      public func request(raw: String,completionHandler: @escaping ((_ completion: Completion?)->Void)) {
         let request = HTTPRequest(authorization: "Bearer "+apiKey)
         request.postJson(url: chat.completionURL,content: raw,responseHandler: { response in
            completionHandler(jsonDecode(Completion.self,from: response))
         },errorHandler: { (urlResponse,error) in
            completionHandler(nil)
         })
      }
      
      /// Make a request to ChatGPT completions
      /// - Parameters:
      ///   - chatRequest: Structured data to be sent, conforms to the structured data requested by ChatGPT
      ///   - responseHandler: Called on any progress, which may have a null completion object
      public func request(chatRequest: Jsonable,completionHandler: @escaping ((_ completion: Completion?)->Void)) {
         if let raw = chatRequest.toJson() {
            request(raw: raw,completionHandler: completionHandler)
         } else {
            // Couldn't make json string
            completionHandler(nil)
         }
      }
      
      /// Make a request to ChatGPT completions
      /// - Parameters:
      ///   - message: Basic string that is a message to be sent to ChatGPT (it is then wrapped in the structure)
      ///   - completionHandler: Called on any progress, which may have a null completion object
      public func request(message: String,completionHandler: @escaping ((_ completion: Completion?)->Void)) {
         let chatRequest = ChatRequest(messages: [Message(content: message)])
         if let raw = chatRequest.toJson() {
            request(raw: raw,completionHandler: completionHandler)
         } else {
            // Couldn't make json string
            completionHandler(nil)
         }
      }
   }
 }
