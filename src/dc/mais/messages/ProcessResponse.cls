Class dc.mais.messages.ProcessResponse Extends (Ens.Request, %JSON.Adaptor)
{

Property Content As %String(%JSONFIELDNAME = "content", MAXLEN = "");

Property History As %String(%JSONFIELDNAME = "history", MAXLEN = "");

Property CurrentAgent As %String(%JSONFIELDNAME = "current_agent", MAXLEN = 100);

Storage Default
{
<Data name="ProcessResponseDefaultData">
<Subscript>"ProcessResponse"</Subscript>
<Value name="1">
<Value>History</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>CurrentAgent</Value>
</Value>
</Data>
<DefaultData>ProcessResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
