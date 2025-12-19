/// 
Class dc.sample.process.Orchestrator Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='dc.mais.messages.ProcessRequest' response='Ens.Response' height='2500' width='2000' >
<context>
<property name='target' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='250' />
</parameters>
</property>
<property name='origin' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='250' />
</parameters>
</property>
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

<property name='ToolResultData' type='%String' instantiate='0'>
        <parameters> <parameter name='MAXLEN' value='' /> </parameters>
    </property>

<property name='History' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='ToolCall' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='CurrentResponse' type='%String' instantiate='0' >
        <parameters>
            <parameter name='MAXLEN' value='' />
        </parameters>
    </property>

<property name='RunLoop' type='%Boolean' initialexpression='1' instantiate='0' />
<property name='CurrentToolName' type='%String' instantiate='0' />
<property name='CurrentToolId' type='%String' instantiate='0' />
<property name='ToolResult' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
</context>
<sequence xend='200' yend='1550' >
<assign name="ToolCall" property="context.ToolCall" value="&quot;&quot;" action="set" languageOverride="" xpos='200' ypos='250' />
<assign name="Assignee" property="context.target" value="request.Assignee" action="set" languageOverride="" xpos='200' ypos='350' />
<assign name="Sender" property="context.origin" value="request.Sender" action="set" languageOverride="" xpos='200' ypos='450' />
<assign name="Content" property="context.userContent" value="request.Content" action="set" languageOverride="" xpos='200' ypos='550' />
<if name='CheckBegining' condition='(context.target="")&amp;&amp;(request.History="")' xpos='200' ypos='650' xend='200' yend='900' >
<true>
<assign name="Begin" property="context.target" value="&quot;greeter&quot;" action="set" languageOverride="" xpos='335' ypos='800' />
</true>
</if>
<switch name='Target' xpos='200' ypos='1000' xend='200' yend='1350' >
<case condition='context.target="greeter"' name='Greeter' >
<call name='Agent Greeter' target='Agent.Greeter' async='0' xpos='335' ypos='1150' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;xxx&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='Agent Greeter' type='all' xpos='335' ypos='1250' />
</case>
<case condition='context.target="menu_expert"' name='Menu Expert' >
<call name='Agent Menu Expert' target='Agent.MenuExpert' async='1' xpos='605' ypos='1150' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
<assign property="context.CurrentTools" value="callresponse.Tools" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='Agent Menu Expert' type='all' xpos='605' ypos='1250' />
</case>
<default name='default' />
</switch>
<while name='Agent Loop' condition='context.RunLoop=1' xpos='200' ypos='1450' xend='200' yend='1250' >
<code name='Prep AI Call'>
<![CDATA[
    // If we are in the first iteration (History is empty or small), send User Input.
    // If returning from a Tool execution (CurrentToolId populated), clear User Input
    // and shift focus to the tool result.
    
    If (context.CurrentToolId '= "") {
       Set context.userContent = "" // Clear user input to prevent repetition
       // ToolResult and ToolId should already be populated by the previous Switch
    }
]]>
</code>
<call name='AI' target='LLM' async='0' xpos='200' ypos='250' >
<request type='dc.mais.messages.LLMRequest' >
<assign property="callrequest.Content" value="context.CurrentSystemPrompt" action="set" languageOverride="" />
<assign property="callrequest.UserContent" value="context.userContent" action="set" languageOverride="" />
<assign property="callrequest.Parameter" value="context.CurrentTools" />
<assign property="callrequest.ToolOutput" value="context.ToolResultData" />
<assign property="callrequest.ToolCallId" value="context.CurrentToolId" />
<assign property="callrequest.History" value="context.History" />
</request>
<response type='dc.mais.messages.LLMResponse' >
<assign property="context.ToolCall" value="callresponse.ToolCalls" action="set" languageOverride="" />
<assign property="context.CurrentResponse" value="callresponse.Content" action="set" />
</response>
</call>
<sync name='Wait' calls='AI' type='all' xpos='200' ypos='350' />
<if name='Check Tool Call' condition='context.ToolCall=""' xpos='200' ypos='450' xend='200' yend='1150' >
<true>
<assign name="Stop Loop" property="context.RunLoop" value="0" action="set" languageOverride="" xpos='200' ypos='600' />
</true>
<false>
<code name='Parse Tool Call and Update History'>
<![CDATA[
    Set context.CurrentToolName = ""
    Set context.CurrentToolId = ""
    
    // Safeguard: If string is empty or "[]", do nothing
    If ($Length(context.ToolCall) > 5) {
        Try {
            // Convert JSON string to IRIS Dynamic Array
            Set tArray = [].%FromJSON(context.ToolCall)
            
            // Get the first requested tool (index 0)
            // If multiple simultaneous tools support is needed, an inner loop is required here
            Set tItem = tArray.%Get(0)
            
            If $IsObject(tItem) {
                Set context.CurrentToolName = tItem.function.name
                Set context.CurrentToolId = tItem.id
                
                // --- CRUCIAL: Update History with the Tool REQUEST ---
                // If we don't add this, the LLM will not accept the tool response later
                
                // 1. Load current history
                Set tHistArray = [].%FromJSON(context.History)
                If (tHistArray = "") Set tHistArray = []
                
                // 2. Create Assistant message containing the Tool Call
                Set tMsg = {}
                Set tMsg.role = "assistant"
                Set tMsg.content = context.CurrentResponse // The text content (e.g., "Let me check...")
                Set tMsg."tool_calls" = tArray // The original tools array
                
                // 3. Save to context
                Do tHistArray.%Push(tMsg)
                Set context.History = tHistArray.%ToJSON()
                // -----------------------------------------------------------
            }
        } Catch e {
            $$$LOGERROR("Parse error: " _ e.DisplayString())
        }
    }
]]>
</code>

<switch name='Select Tool' xpos='470' ypos='700' xend='470' yend='1050' >
<case condition='context.CurrentToolName="get_menu"' name='Get Menu' >
<call name='GetMenu Tool' target='Tool.GetMenu' async='0' xpos='605' ypos='850' >
<request type='dc.sample.message.Request' >
        </request>
<response type='dc.sample.message.MenuResponse' >
    <assign property="context.ToolResultData" value="callresponse.Menu" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='Agent Menu Expert' type='all' xpos='605' ypos='950' />
</case>
<default name='default' />
</switch>
</false>
</if>
</while>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
