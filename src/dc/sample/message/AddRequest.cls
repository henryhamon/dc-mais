Class dc.sample.message.AddRequest Extends (Ens.Request, %JSON.Adaptor)
{

Property ItemName As %String(MAXLEN = "");

Property Extras As %String(MAXLEN = "");

Property SpecialRequests As %String(MAXLEN = "");

Property Quantity As %Integer [ InitialExpression = 1 ];

Storage Default
{
<Data name="AddRequestDefaultData">
<Subscript>"AddRequest"</Subscript>
<Value name="1">
<Value>ItemName</Value>
</Value>
<Value name="2">
<Value>Extras</Value>
</Value>
<Value name="3">
<Value>SpecialRequests</Value>
</Value>
<Value name="4">
<Value>Quantity</Value>
</Value>
</Data>
<DefaultData>AddRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
