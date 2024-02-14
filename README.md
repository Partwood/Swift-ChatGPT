# ChatGPT

A package providing ChatGTP functionality, based on the OpenAI API found here: https://platform.openai.com/docs/api-reference/introduction

General chat usage examples can be found in tests, some examples follow

Main structures with value: ChatGPT.chat, ChatRequest, Completion, Choice, Message

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
