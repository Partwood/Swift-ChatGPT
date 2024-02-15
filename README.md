# ChatGPT

A package providing ChatGTP functionality, based on the OpenAI API found [here](https://platform.openai.com/docs/api-reference/introduction).

General chat usage examples can be found in tests, some examples follow

Main structures:

- ChatGPT.chat
- ChatRequest
- Completion
- Choice
- Message

---

## Examples

```
// With a request object
let request = ChatRequest(messages: [Message(content: "Tell me a story")])

let chat = ChatGPT.chat(apiKey: apiKey)
chat.request(chatRequest: BadJsonable(),completionHandler: { completion in
   if let validCompletion = completion {
      validCompletion.choices.forEach({ choice in
         print(choice.message.content)
      })
   }
})

// Just a string
let chat = ChatGPT.chat(apiKey: apiKey)
chat.request(message: "Tell me a story",completionHandler: { completion in
   if let validCompletion = completion {
      validCompletion.choices.forEach({ choice in
         print(choice.message.content)
      })
   }
})

// Building on an existing conversation
 let request = ChatRequest(messages: [Message(content: "Hello, how are you?")])

 let chat = ChatGPT.chat(apiKey: apiKey, organization: "organization") 
 chat.request(chatRequest: request,completionHandler: { completion in
    if let validCompletion = completion {
       validCompletion.choices.forEach({ choice in
          debug(choice.message.content)
       })
       
       let nextRequest = request.merge(validCompletion, followUp: [Message(content: "What time is it in Gary In if it is 8 am in Boston MA?")])
       chat.request(chatRequest: nextRequest, completionHandler: { completion in
          if let validCompletion = completion {
             validCompletion.choices.forEach({ choice in
                debug(choice.message.content)
             })
          }
       })
    }
 })
 ```
 
## Async Examples (in iOS 13 or higher)

```
// With a request object
let request = ChatRequest(messages: [Message(content: "Tell me a story")])

let chat = ChatGPT.chat(apiKey: apiKey)
if let completion = await chat.request(chatRequest: request) {
   completion.choices.forEach({ choice in
      debug(choice.message.content)
   })
}

// Just a string
let chat = ChatGPT.chat(apiKey: apiKey)

if let completion = await chat.request(message: "Tell me a story") {
   completion.choices.forEach({ choice in
      debug(choice.message.content)
   })
}
```
