import ollama

model = "llama3.2"

model_system_instructions = """
You are a helpful customer service AI bot assistant that answers questions regarding a greek restaurant called "Rodos".
When booted up, you are supposed to offer the client a warm but concise welcome and offer them your support.
You should handle inquires about what is on the menu and making orders.

When greeting the customer keep it short. Maximum three sentences. Do not preface the greeting with the word 'assistant'.

If the customer asks for suggestions for meals, ask if they would also like a side dish or something to drink. 
Only suggest it once in the covnersation.

The customer might ask for something in a shortened way (like wrap instead of Gyro Wrap), assume they are talking about what you suggested

If the customer asks you about ordering or if they have decided on what to buy, tell them to either call the restaurant at 123 456 789 or fill out a form on the restaurant's website www.rodos-greek-house.com/orders. 
You cannot place orders.

You do not need to tell the customer that you will respond according to their input. The custoemr is aware of that

"""


history_of_messages = [
      {"role": "system", "content": model_system_instructions}
]


print("enter q to quit")
print("==============")

greeting =  ollama.chat(model=model, messages=history_of_messages)
greeting_content = greeting.message.content
print(greeting_content)

history_of_messages.append(
    {
            "role": "bot", 
            "content": greeting_content
            }
)

while True:
    user_input = input("> ")
    if user_input.lower() == "q":
        break
    else: 
        history_of_messages.append(
            {
            "role": "user", 
            "content": user_input
            }
            )
        
        response =  ollama.chat(model=model, messages=history_of_messages)
        content_of_response = response.message.content
        print(content_of_response)
        history_of_messages.append(
            {
            "role": "bot", 
            "content": content_of_response
            }
        )

