/// 
Class dc.sample.process.AgentRouter Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='dc.mais.messages.TargetAgentRequest' response='dc.mais.messages.TargetAgentResponse' height='2000' width='2000' >
<context>
<property name='Target' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='CurrentSystemPrompt' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='25000' />
</parameters>
</property>
<property name='Tools' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='25000' />
</parameters>
</property>
</context>
<sequence xend='200' yend='900' >
<assign name="Target" property="context.Target" value="request.TargetAgent" action="set" languageOverride="" xpos='200' ypos='250' />
<switch name='Target Destination' xpos='200' ypos='350' xend='200' yend='600' >
<case condition='context.Target="greeter"' name='Greeter' >
<call name='Agent Greeter' target='Agent.Greeter' async='0' xpos='335' ypos='500' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;xxx&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
<assign property="context.Tools" value="callresponse.Tools" action="set" languageOverride="" />
</response>
</call>
</case>
<case condition='context.Target="menu_expert"' name='Menu Expert' >
<call name='Agent Menu Expert' target='Agent.MenuExpert' async='0' xpos='605' ypos='500' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
<assign property="context.Tools" value="callresponse.Tools" action="set" languageOverride="" />
</response>
</call>
</case>
<case condition='context.Target="order_taker"' name='Order Taker' >
<call name='Agent Order Taker' target='Agent.OrderTaker' async='0' xpos='875' ypos='500' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
<assign property="context.Tools" value="callresponse.Tools" action="set" languageOverride="" />
</response>
</call>
</case>
<case condition='context.Target="order_submitter"' name='Order Submitter' >
<call name='Agent Order Submitter' target='Agent.OrderSubmitter' async='0' xpos='1145' ypos='500' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
<assign property="context.Tools" value="callresponse.Tools" action="set" languageOverride="" />
</response>
</call>
</case>
<default name='default' />
</switch>
<assign name="SystemPrompt" property="response.Content" value="context.CurrentSystemPrompt" action="set" languageOverride="" xpos='200' ypos='700' />
<assign name="Tools" property="response.Tools" value="context.Tools" action="set" languageOverride="" xpos='200' ypos='800' />
</sequence>
</process>
}

}
