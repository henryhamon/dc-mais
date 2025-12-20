Class dc.sample.message.PlaceOrderRequest Extends (Ens.Request, %JSON.Adaptor)
{

Property TableNumber As %String(MAXLEN = "");

Storage Default
{
<Data name="PlaceOrderRequestDefaultData">
<Subscript>"PlaceOrderRequest"</Subscript>
<Value name="1">
<Value>TableNumber</Value>
</Value>
</Data>
<DefaultData>PlaceOrderRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
