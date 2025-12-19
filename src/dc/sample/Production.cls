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
    <Setting Target="Adapter" Name="OutputInstructions">- Provide detailed, appetizing descriptions of dishes
- Share interesting facts about French cuisine and preparations
- Suggest wine pairings and complementary items
- Answer questions about ingredients and dietary restrictions
- Be passionate and knowledgeable about the food
- When customer decides to order, confirm and handoff to OrderTaker</Setting>
    <Setting Target="Adapter" Name="Role">Provide detailed information about menu items, ingredients, and recommendations</Setting>
    <Setting Target="Adapter" Name="Tasks">- Explain menu items in detail with passion and knowledge
- Recommend dishes based on customer preferences and dietary needs
- Suggest appetizers, mains, desserts, and beverage pairings
- Answer questions about ingredients, preparation methods, and flavors
- Identify when customer is ready to order
- Handoff to OrderTaker when customer decides what to order</Setting>
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
    <Setting Target="Adapter" Name="Tools">add_to_order, get_order, clear_order, handoff_to_agent</Setting>
  </Item>
  <Item Name="Agent.OrderConfirmer" Category="Agents" ClassName="dc.mais.operation.Agent" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Goal">Ensure 100% order accuracy by double-checking all details with the customer</Setting>
    <Setting Target="Adapter" Name="Name">OrderConfirmer</Setting>
    <Setting Target="Adapter" Name="OutputInstructions">- Display the complete order summary clearly and professionally
- Ask customer to review and confirm each item
- If changes needed, acknowledge and handoff back to OrderTaker
- If confirmed, ask for table number and handoff to OrderSubmitter
- Be thorough and patient</Setting>
    <Setting Target="Adapter" Name="Role">Review and confirm orders before sending to kitchen</Setting>
    <Setting Target="Adapter" Name="Target">order_submitter</Setting>
    <Setting Target="Adapter" Name="Tasks">- Use confirm_order to display complete order summary
- Present each item clearly with prices and total
- Ask customer to confirm or request modifications
- If modifications needed, handoff back to OrderTakerBot
- If confirmed, collect table number
- Handoff to OrderSubmitter with table number</Setting>
    <Setting Target="Adapter" Name="Tools">confirm_order, get_order, handoff_to_agent</Setting>
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
    <Setting Target="Adapter" Name="Tools">place_order, get_order, handoff_to_agent</Setting>
    <Setting Target="Adapter" Name="Target">order_taker</Setting>
  </Item>
  <Item Name="Tool.GetMenu" Category="Tools" ClassName="dc.sample.operation.Menu" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
