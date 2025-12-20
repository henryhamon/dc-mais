Class dc.sample.message.AddResponse Extends Ens.Response
{

Property Message As %String(MAXLEN = "");

Property Success As %Boolean [ InitialExpression = 0 ];

Property Item As %String(MAXLEN = "");

Storage Default
{
<Data name="AddResponseDefaultData">
<Subscript>"AddResponse"</Subscript>
<Value name="1">
<Value>Message</Value>
</Value>
<Value name="2">
<Value>Success</Value>
</Value>
<Value name="3">
<Value>Item</Value>
</Value>
</Data>
<DefaultData>AddResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
