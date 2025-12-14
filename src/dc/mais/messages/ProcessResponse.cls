Class dc.mais.messages.ProcessResponse Extends (Ens.Request, %JSON.Adaptor)
{

Property History As %String(%JSONFIELDNAME = "history", MAXLEN = "");

Storage Default
{
<Data name="ProcessResponseDefaultData">
<Subscript>"ProcessResponse"</Subscript>
<Value name="1">
<Value>History</Value>
</Value>
</Data>
<DefaultData>ProcessResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
