Class dc.sample.message.CurrentOrderResponse Extends Ens.Response
{

Property Message As %String(MAXLEN = "");

Property Success As %Boolean [ InitialExpression = 0 ];

Property Items As %String(MAXLEN = "");

Storage Default
{
<Data name="CurrentOrderResponseDefaultData">
<Subscript>"CurrentOrderResponse"</Subscript>
<Value name="1">
<Value>Message</Value>
</Value>
<Value name="2">
<Value>Success</Value>
</Value>
<Value name="3">
<Value>Items</Value>
</Value>
</Data>
<DefaultData>CurrentOrderResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
