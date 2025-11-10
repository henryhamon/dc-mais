Class dc.mais.messages.AgentRequest Extends Ens.Request
{

Property Input As %String(MAXLEN = "");

Storage Default
{
<Data name="AgentRequestDefaultData">
<Subscript>"AgentRequest"</Subscript>
<Value name="1">
<Value>Input</Value>
</Value>
</Data>
<DefaultData>AgentRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
