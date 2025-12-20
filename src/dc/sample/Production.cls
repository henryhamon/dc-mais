Class dc.sample.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.sample.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="LLM" Category="" ClassName="dc.mais.operation.LLM" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="APIKeysConfig">AZURE_API_BASE,AZURE_API_VERSION,AZURE_API_KEY</Setting>
    <Setting Target="Adapter" Name="DefaultModel">azure/gpt-5-chat</Setting>
    <Setting Target="Adapter" Name="BaseURL">https://fb2adfc2ac08.ngrok-free.app/api/generate</Setting>
  </Item>
  <Item Name="Agent.Greeter" Category="Agents" ClassName="dc.mais.operation.Agent" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Name">Greeter</Setting>
    <Setting Target="Adapter" Name="Goal">Make customers feel welcomed and guide them to the appropriate specialis</Setting>
    <Setting Target="Adapter" Name="OutputInstructions">- Greet customers warmly and professionally
- Offer to show the menu or answer general questions
- Keep responses concise and inviting (2-3 sentences max)
- Always end with a question to engage the customer
- Be friendly and approachable</Setting>
    <Setting Target="Adapter" Name="Role">Welcome customers and provide initial menu information</Setting>
    <Setting Target="Adapter" Name="Tasks">- Welcome customers with a warm, professional greeting,
- Provide brief overview of restaurant specialties,
- Answer general questions about the bistro
- Identify customer needs (menu info, ordering, or general questions)
- Handoff to MenuExpert when customer wants detailed menu information</Setting>
    <Setting Target="Adapter" Name="Target">menu_expert</Setting>
  </Item>
  <Item Name="Agent.MenuExpert" Category="Agents" ClassName="dc.mais.operation.Agent" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Goal">Help customers make informed decisions by sharing expertise about dishes</Setting>
    <Setting Target="Adapter" Name="Name">MenuExpert</Setting>
    <Setting Target="Adapter" Name="OutputInstructions">- Provide detailed, appetizing descriptions ONLY when asked for information
- Share interesting facts about French cuisine
- Suggest pairings
- STOP immediately if the user wants to order
- DO NOT ask for confirmation to add items. Handoff immediately.
- DO NOT process the order yourself.</Setting>
    <Setting Target="Adapter" Name="Role">Provide detailed information about menu items, ingredients, and recommendations</Setting>
    <Setting Target="Adapter" Name="Tasks"><![CDATA[- Explain menu items in detail with passion and knowledge
- Recommend dishes based on customer preferences
- Suggest appetizers, mains, desserts, and beverage pairings
- Answer questions about ingredients
- CRITICAL: If the customer indicates intent to order (e.g., "I want", "I'll have"), IMMEDIATELY use handoff_to_agent("OrderTaker"). Do not write a response first.</Setting>]]></Setting>
    <Setting Target="Adapter" Name="Target">order_taker</Setting>
    <Setting Target="Adapter" Name="Tools">[{
        "type": "function",
        "function": {
            "name": "get_menu",
            "description": "Get the full bistro menu",
            "parameters": {
                "type": "object",
                "properties": {},
                "required": []
            }
        }
    }]</Setting>
  </Item>
  <Item Name="Orchestrator" Category="" ClassName="dc.sample.process.Orchestrator" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Agent.OrderTaker" Category="Agents" ClassName="dc.mais.operation.Agent" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Goal">Create complete and accurate orders by carefully adding items and confirming details</Setting>
    <Setting Target="Adapter" Name="Name">OrderTaker</Setting>
    <Setting Target="Adapter" Name="OutputInstructions">- Confirm each item as you add it to the order
- Ask about quantities, extras, and special requests
- Be detail-oriented and double-check information
- Suggest complementary items (sides, extras) naturally
- After adding all items, inform customer and handoff to OrderConfirme</Setting>
    <Setting Target="Adapter" Name="Role">Accurately capture and build customer orders</Setting>
    <Setting Target="Adapter" Name="Tasks">- Add items to the order one by one using add_to_order
- Verify quantities, extras, and special requests for each item
- Suggest extras like side salads, sauces, or bread when appropriate
- Use get_order to track current order status
- Ensure all customer requests are captured accurately
- Handoff to OrderConfirmer when customer finishes orderin</Setting>
    <Setting Target="Adapter" Name="Tools">[
    {
        "type": "function",
        "function": {
            "name": "add_to_order",
            "description": "Add an item to the current order. Use this when the customer wants to add a dish or drink.",
            "parameters": {
                "type": "object",
                "properties": {
                    "item_name": {
                        "type": "string",
                        "description": "The exact name of the item from the menu (e.g., 'Coq au Vin', 'Coke')."
                    },
                    "quantity": {
                        "type": "integer",
                        "description": "The number of items to order. Defaults to 1 if not specified."
                    },
                    "extras": {
                        "type": "string",
                        "description": "Any extras or sides requested (e.g., 'extra cheese', 'side salad')."
                    },
                    "special_requests": {
                        "type": "string",
                        "description": "Special dietary requests or modifications (e.g., 'no onions', 'sauce on the side')."
                    }
                },
                "required": ["item_name"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "get_order",
            "description": "Retrieve the current list of items in the order to review/confirm with the customer.",
            "parameters": {
                "type": "object",
                "properties": {},
                "required": []
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "clear_order",
            "description": "Remove all items from the current order. Use only if customer wants to restart completely.",
            "parameters": {
                "type": "object",
                "properties": {},
                "required": []
            }
        }
    }
]</Setting>
  </Item>
  <Item Name="Agent.OrderSubmitter" Category="Agents" ClassName="dc.mais.operation.Agent" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Goal">Complete the ordering process by submitting to kitchen and providing confirmation detail</Setting>
    <Setting Target="Adapter" Name="Name">OrderSubmitter</Setting>
    <Setting Target="Adapter" Name="OutputInstructions">- Collect table number if not already provided
- Submit the order and provide confirmation details
- Include order ID, total amount, and estimated preparation time
- Thank the customer warmly and professionally
- Wish them an excellent meal and dining experience</Setting>
    <Setting Target="Adapter" Name="Role">Submit confirmed orders to the kitchen and provide order confirmation</Setting>
    <Setting Target="Adapter" Name="Tasks">- Verify table number is available
- Submit order to kitchen using place_order
- Provide order confirmation with order ID
- Share estimated preparation time with customer
- Thank customer and wish them an excellent meal</Setting>
    <Setting Target="Adapter" Name="Tools">[
    {
        "type": "function",
        "function": {
            "name": "place_order",
            "description": "Finalize and submit the order to the kitchen. Returns the order ID and total.",
            "parameters": {
                "type": "object",
                "properties": {},
                "required": []
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "get_order",
            "description": "Get the final order details to confirm before submitting.",
            "parameters": {
                "type": "object",
                "properties": {},
                "required": []
            }
        }
    }
]</Setting>
    <Setting Target="Adapter" Name="Target">order_taker</Setting>
  </Item>
  <Item Name="Tool.GetMenu" Category="Tools" ClassName="dc.sample.operation.Menu" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Tool.AddToOrder" Category="Tools" ClassName="dc.sample.operation.AddToOrder" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Tool.ClearOrder" Category="Tools" ClassName="dc.sample.operation.ClearOrder" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Tool.GetOrder" Category="Tools" ClassName="dc.sample.operation.GetOrder" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Tool.PlaceOrder" Category="Tools" ClassName="dc.sample.operation.PlaceOrder" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
