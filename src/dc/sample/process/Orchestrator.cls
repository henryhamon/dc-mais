/// 
Class dc.sample.process.Orchestrator Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='dc.mais.messages.ProcessRequest' response='Ens.Response' height='2000' width='2000' >
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
</context>
<sequence xend='200' yend='1450' >
<assign name="Assignee" property="context.target" value="request.Assignee" action="set" languageOverride="" xpos='200' ypos='250' />
<assign name="Sender" property="context.origin" value="request.Sender" action="set" languageOverride="" xpos='200' ypos='350' />
<assign name="Content" property="context.userContent" value="request.Content" action="set" languageOverride="" xpos='727' ypos='396' />
<if name='CheckBegining' condition='(context.target="")&amp;&amp;(request.History="")' xpos='200' ypos='450' xend='200' yend='700' >
<true>
<assign name="Begin" property="context.target" value="&quot;greeter&quot;" action="set" languageOverride="" xpos='335' ypos='600' />
</true>
</if>
<switch name='Target' xpos='200' ypos='800' xend='200' yend='1150' >
<case condition='context.target="greeter"' name='Greeter' >
<call name='Agent Greeter' target='Agent.Greeter' async='0' xpos='335' ypos='950' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;xxx&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='Agent Greeter' type='all' xpos='335' ypos='1050' />
</case>
<case condition='context.target="menu_expert"' name='Menu Expert' >
<call name='Agent Menu Expert' target='Agent.MenuExpert' async='1' xpos='605' ypos='950' >
<request type='dc.mais.messages.AgentRequest' >
<assign property="callrequest.UserInput" value="&quot;&quot;" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.AgentResponse' >
<assign property="context.CurrentSystemPrompt" value="callresponse.Content" action="set" languageOverride="" />
<assign property="context.CurrentTools" value="callresponse.Tools" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='Agent Menu Expert' type='all' xpos='605' ypos='1050' />
</case>
<default name='default' />
</switch>
<call name='AI' target='LLM' async='0' xpos='200' ypos='1250' >
<request type='dc.mais.messages.LLMRequest' >
<assign property="callrequest.Content" value="context.CurrentSystemPrompt" action="set" languageOverride="" />
<assign property="callrequest.UserContent" value="context.userContent" action="set" languageOverride="" />
<assign property="callrequest.Parameter" value="context.CurrentTools" action="set" languageOverride="" />
</request>
<response type='dc.mais.messages.LLMResponse' />
</call>
<sync name='Wait' calls='AI' type='all' xpos='200' ypos='1350' />
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
