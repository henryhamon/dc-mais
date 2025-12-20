Class dc.sample.message.PlaceOrderResponse Extends Ens.Response
{

Property Message As %String(MAXLEN = "");

Property Success As %Boolean [ InitialExpression = 0 ];

Property OrderId As %Integer;

Property TableNumber As %Integer;

Property Total As %Numeric;

Property Items As %String(MAXLEN = "");

Property EstimatedTime As %String(MAXLEN = "");

Storage Default
{
<Data name="PlaceOrderResponseDefaultData">
<Subscript>"PlaceOrderResponse"</Subscript>
<Value name="1">
<Value>Message</Value>
</Value>
<Value name="2">
<Value>Success</Value>
</Value>
<Value name="3">
<Value>OrderId</Value>
</Value>
<Value name="4">
<Value>TableNumber</Value>
</Value>
<Value name="5">
<Value>Total</Value>
</Value>
<Value name="6">
<Value>Items</Value>
</Value>
<Value name="7">
<Value>EstimatedTime</Value>
</Value>
</Data>
<DefaultData>PlaceOrderResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
