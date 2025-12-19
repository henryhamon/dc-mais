Class dc.mais.messages.LLMRequest Extends (Ens.Response, %JSON.Adaptor, %XML.Adaptor)
{

/// The model to use (e.g., "gpt-4", "claude-2")
Property Model As %String(MAXLEN = 100);

/// Agent content
Property Content As %String(MAXLEN = "");

/// User interaction content
Property UserContent As %String(MAXLEN = "");

/// Array of messages objects
Property History As %String(MAXLEN = "");

/// O ID da chamada gerado pela LLM anteriormente (ex: "call_abc123")
Property ToolCallId As %String(MAXLEN = 100);

/// O JSON retornado pela execução da ferramenta
Property ToolOutput As %String(MAXLEN = "");

/// Definição das ferramentas (Schema)
Property Parameter As %String(MAXLEN = "");

Storage Default
{
<Data name="LLMRequestDefaultData">
<Subscript>"LLMRequest"</Subscript>
<Value name="1">
<Value>Model</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>UserContent</Value>
</Value>
<Value name="4">
<Value>History</Value>
</Value>
<Value name="5">
<Value>Parameter</Value>
</Value>
<Value name="6">
<Value>Tool</Value>
</Value>
<Value name="7">
<Value>ToolCallId</Value>
</Value>
<Value name="8">
<Value>ToolOutput</Value>
</Value>
</Data>
<DefaultData>LLMRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
