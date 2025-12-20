/// 
Class dc.sample.process.Orchestrator Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='dc.mais.messages.ProcessRequest' response='Ens.Response' height='2500' width='2555' >
<context>
<property name='target' type='%String' initialexpression='""' instantiate='0' />
<property name='origin' type='%String' initialexpression='""' instantiate='0' />
<property name='CurrentSystemPrompt' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='CurrentTools' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='userContent' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='ToolResultData' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='History' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='25000' />
</parameters>
</property>
<property name='IsHandoff' type='%Boolean' initialexpression='0' instantiate='0' />
<property name='ToolCall' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='CurrentResponse' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='RunLoop' type='%Boolean' initialexpression='1' instantiate='0' />
<property name='CurrentToolName' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='CurrentToolId' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='ToolResult' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='TableNumber' type='%Integer' initialexpression='$Random(20)+1' instantiate='0' />
</context>
<sequence xend='200' yend='1100' >
<assign name="ToolCall" property="context.ToolCall" value="&quot;&quot;" action="set" languageOverride="" xpos='200' ypos='250' />
<assign name="Assignee" property="context.target" value="request.Assignee" action="set" languageOverride="" xpos='200' ypos='350' />
<assign name="Sender" property="context.origin" value="request.Sender" action="set" languageOverride="" xpos='200' ypos='450' />
<assign name="Content" property="context.userContent" value="request.Content" action="set" languageOverride="" xpos='200' ypos='550' />
<if name='CheckBegining' condition='(context.target="")&amp;&amp;(request.History="")' xpos='200' ypos='650' xend='200' yend='900' >
<true>
<assign name="Begin" property="context.target" value="&quot;greeter&quot;" action="set" languageOverride="" xpos='335' ypos='800' />
</true>
</if>
<while name='Conversation Flow' condition='1' xpos='200' ypos='1000' xend='200' yend='1250' >
<assign name="Reset Handoff" property="context.IsHandoff" value="0" action="set" languageOverride="" xpos='200' ypos='250' />
<assign name="Reset Agent Loop" property="context.RunLoop" value="1" action="set" languageOverride="" xpos='200' ypos='350' />
<switch name='Target' xpos='200' ypos='450' xend='200' yend='700' >
<case condition='context.target="greeter"' name='Greeter' >
<call name='Agent Greeter' target='Agent.Greeter' async='0' xpos='335' ypos='600' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;xxx&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
</response>
</call>
</case>
<case condition='context.target="menu_expert"' name='Menu Expert' >
<call name='Agent Menu Expert' target='Agent.MenuExpert' async='0' xpos='605' ypos='600' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
<assign property="context.CurrentTools" value="callresponse.Tools" action="set" languageOverride="" />
</response>
</call>
</case>
<case condition='context.target="order_taker"' name='Order Taker' >
<call name='Agent Order Taker' target='Agent.OrderTaker' async='1' xpos='944' ypos='579' >
<request type='dc.sample.message.AddRequest' />
<response type='dc.sample.message.AddResponse' />
</call>
</case>
<case condition='context.target="order_submitter"' name='Order Submitter' >
<call name='Agent Order Submitter' target='Agent.OrderSubmitter' async='1' xpos='1252' ypos='570' >
<request type='dc.mais.messages.AgentRequest' />
<response type='dc.mais.messages.AgentResponse' />
</call>
</case>
<default name='default' />
</switch>
<while name='Agent Loop' condition='context.RunLoop=1' xpos='200' ypos='800' xend='200' yend='1350' >
<code name='Prep AI Call' xpos='200' ypos='250' >
<![CDATA[
                // If returning from a Tool execution, clear User Input to shift focus to tool result
                If (context.CurrentToolId '= "") {
                    Set context.userContent = "" 
                }
            ]]>
</code>
<call name='AI' target='LLM' async='0' xpos='200' ypos='350' >
<request type='dc.mais.messages.LLMRequest' >
<assign property="callrequest.Content" value="context.CurrentSystemPrompt" action="set" languageOverride="" />
<assign property="callrequest.UserContent" value="context.userContent" action="set" languageOverride="" />
<assign property="callrequest.Parameter" value="context.CurrentTools" action="set" languageOverride="" />
<assign property="callrequest.ToolOutput" value="context.ToolResultData" action="set" languageOverride="" />
<assign property="callrequest.ToolCallId" value="context.CurrentToolId" action="set" languageOverride="" />
<assign property="callrequest.History" value="context.History" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.LLMResponse' >
<assign property="context.ToolCall" value="callresponse.ToolCalls" action="set" languageOverride="" />
<assign property="context.CurrentResponse" value="callresponse.Content" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='AI' type='all' xpos='200' ypos='450' />
<if name='Check Tool Call' condition='context.ToolCall=""' xpos='200' ypos='550' xend='200' yend='1250' >
<true>
<assign name="Stop Loop" property="context.RunLoop" value="0" action="set" languageOverride="" xpos='200' ypos='700' />
</true>
<false>
<code name='Parse Tool Call' xpos='470' ypos='700' >
<![CDATA[
                        Set context.CurrentToolName = ""
                        Set context.CurrentToolId = ""
                        
                        If ($Length(context.ToolCall) > 5) {
                            Try {
                                Set tArray = [].%FromJSON(context.ToolCall)
                                Set tItem = tArray.%Get(0)
                                
                                If $IsObject(tItem) {
                                    Set context.CurrentToolName = tItem.function.name
                                    Set context.CurrentToolId = tItem.id
                                    
                                    // Update History with the REQUEST
                                    Set tHistArray = [].%FromJSON(context.History)
                                    If (tHistArray = "") Set tHistArray = []
                                    
                                    Set tMsg = {}
                                    Set tMsg.role = "assistant"
                                    Set tMsg.content = context.CurrentResponse
                                    Set tMsg."tool_calls" = tArray
                                    
                                    Do tHistArray.%Push(tMsg)
                                    Set context.History = tHistArray.%ToJSON()
                                }
                            } Catch e {
                                $$$LOGERROR("Parse error: " _ e.DisplayString())
                            }
                        }
                    ]]>
</code>
<switch name='Select Tool' xpos='470' ypos='800' xend='470' yend='1150' >
<case condition='context.CurrentToolName="handoff_to_agent"' name='Handoff to agent' >
<code name='Process Handoff' xpos='605' ypos='950' >
<![CDATA[
    // 1. Read arguments to know the target
    Set tArgs = {}.%FromJSON(context.ToolCall).%Get(0).function.arguments
    Set tArgsObj = {}.%FromJSON(tArgs)

    Set tNewTarget = tArgsObj."target_agent"
    Set tReason = tArgsObj."reason"

    // 2. Change the BPL Target
    Set context.target = tNewTarget

    // 3. Update History 
    Set tHist = [].%FromJSON(context.History)
    
    // --- FIX OBRIGATÓRIO: Inserir a resposta da Tool "handoff" ---
    // Isso satisfaz a exigência da API de fechar o par Request/Response
    Set tToolResp = {}
    Set tToolResp.role = "tool"
    Set tToolResp."tool_call_id" = context.CurrentToolId
    Set tToolResp.content = "Handoff to " _ tNewTarget _ " initiated successfully."
    Do tHist.%Push(tToolResp)
    
    // --- Mensagem de Sistema para o Próximo Agente ---
    // Ajuda o novo agente a entender o contexto
    Set tSysMsg = {}
    Set tSysMsg.role = "system"
    Set tSysMsg.content = "Context Handover: Conversation transferred to " _ tNewTarget _ ". Reason: " _ tReason
    Do tHist.%Push(tSysMsg)
    
    // Salva o histórico atualizado
    Set context.History = tHist.%ToJSON()

    // 4. Set Control Flags
    Set context.IsHandoff = 1   // Notifies outer loop to continue
    Set context.RunLoop = 0     // Stops the CURRENT agent's loop
]]>
</code>
</case>
<case condition='context.CurrentToolName="add_to_order"' name='Add To Order' >
<call name='Add to Order' target='Tool.AddToOrder' async='0' xpos='875' ypos='950' >
<request type='dc.sample.message.AddRequest' />
</call>
<sync name='Wait' calls='Add to Order' type='all' xpos='875' ypos='1050' />
</case>
<case condition='context.CurrentToolName="get_menu"' name='Get Menu' >
<call name='GetMenu Tool' target='Tool.GetMenu' async='0' xpos='1145' ypos='950' >
<request type='dc.sample.message.Request' />
<response type='dc.sample.message.MenuResponse' >
<assign property="context.ToolResultData" value="callresponse.Menu" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='GetMenu Tool' type='all' xpos='1145' ypos='1050' />
</case>
<case condition='context.CurrentToolName="get_order"' name='Get Order' >
<call name='Get Order Tool' target='Tool.GetOrder' async='0' xpos='1415' ypos='950' >
<request type='dc.sample.message.Request' />
<response type='dc.sample.message.CurrentOrderResponse' />
</call>
<sync name='Wait' calls='Get Order Tool' type='all' xpos='1415' ypos='1050' />
</case>
<case condition='context.CurrentToolName="place_order"' name='Place Order' >
<call name='Place Order Tool' target='Tool.PlaceOrder' async='0' xpos='1685' ypos='950' >
<request type='dc.sample.message.PlaceOrderRequest' />
<response type='dc.sample.message.PlaceOrderResponse' />
</call>
<sync name='Wait' calls='Place Order Tool' type='all' xpos='1685' ypos='1050' />
</case>
<case condition='context.CurrentToolName="clear_order"' name='Clear Order' >
<call name='Clear Order Tool' target='Tool.ClearOrder' async='0' xpos='1955' ypos='950' >
<request type='dc.sample.message.Request' />
<response type='dc.sample.message.AddResponse' />
</call>
<sync name='Wait' calls='Clear Order Tool' type='all' xpos='1955' ypos='1050' />
</case>
<default name='default' />
</switch>
</false>
</if>
</while>
<if name='Is Handoff?' condition='context.IsHandoff=0' xpos='200' ypos='900' xend='200' yend='1150' >
<true>
<break name='Break' xpos='335' ypos='1050' />
</true>
</if>
</while>
</sequence>
</process>
}

}
