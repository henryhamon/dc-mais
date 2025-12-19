Class dc.mais.messages.ProcessRequest Extends (Ens.Request, %JSON.Adaptor)
{

/// Origin
Property Sender As %String(%JSONFIELDNAME = "sender", MAXLEN = "");

/// Target Agent
Property Assignee As %String(%JSONFIELDNAME = "assignee", MAXLEN = "");

/// Agent Payload
Property Content As %String(%JSONFIELDNAME = "content", MAXLEN = "");

Property History As %String(%JSONFIELDNAME = "history", MAXLEN = "");

Storage Default
{
<Data name="ProcessRequestDefaultData">
<Subscript>"ProcessRequest"</Subscript>
<Value name="1">
<Value>Sender</Value>
</Value>
<Value name="2">
<Value>Assignee</Value>
</Value>
<Value name="3">
<Value>Content</Value>
</Value>
<Value name="4">
<Value>Functions</Value>
</Value>
<Value name="5">
<Value>Tools</Value>
</Value>
<Value name="6">
<Value>History</Value>
</Value>
</Data>
<DefaultData>ProcessRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
