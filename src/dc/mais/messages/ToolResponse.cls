Class dc.mais.messages.ToolResponse Extends Ens.Response
{

/// The result of the tool execution
/// It can be a simple string ("Order confirmed") or a complex JSON (the full menu)
Property Result As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolResponseDefaultData">
<Subscript>"ToolResponse"</Subscript>
<Value name="1">
<Value>Result</Value>
</Value>
</Data>
<DefaultData>ToolResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
