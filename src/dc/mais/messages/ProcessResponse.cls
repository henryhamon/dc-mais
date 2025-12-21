Class dc.mais.messages.ProcessResponse Extends (Ens.Request, %JSON.Adaptor)
{

Property Content As %String(MAXLEN = "");

Property History As %String(%JSONFIELDNAME = "history", MAXLEN = "");

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
</Data>
<DefaultData>ProcessResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
