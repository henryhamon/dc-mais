Class dc.mais.messages.AgentResponse Extends Ens.Response
{

/// The model used for generation
Property Model As %String(MAXLEN = 100);

Property Content As %String(MAXLEN = "");

Property Tools As %String(MAXLEN = "");

/// Error information if the call failed (JSON string)
Property Error As %String(MAXLEN = "");

Storage Default
{
<Data name="AgentResponseDefaultData">
<Subscript>"AgentResponse"</Subscript>
<Value name="1">
<Value>Model</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>Error</Value>
</Value>
<Value name="4">
<Value>Tools</Value>
</Value>
</Data>
<DefaultData>AgentResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
