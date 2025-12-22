Class dc.mais.messages.TargetAgentRequest Extends Ens.Request
{

/// The name of the target agent for routing (e.g., "greeter", "order_taker")
/// The BP Router will use this in the Switch to decide which Operation to call.
Property TargetAgent As %String(MAXLEN = 100);

Storage Default
{
<Data name="TargetAgentRequestDefaultData">
<Subscript>"TargetAgentRequest"</Subscript>
<Value name="1">
<Value>TargetAgent</Value>
</Value>
</Data>
<DefaultData>TargetAgentRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
