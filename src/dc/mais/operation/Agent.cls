Class dc.mais.operation.Agent Extends Ens.BusinessOperation
{

Parameter ADAPTER = "dc.mais.adapter.Agent";

Property Adapter As dc.mais.adapter.Agent;

Parameter INVOCATION = "Queue";

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.mais.messages.AgentRequest">
        <Method>Process</Method>
    </MapItem>
</MapItems>
}

}
