Class dc.mais.operation.Agent Extends Ens.BusinessOperation
{

Parameter ADAPTER = "dc.mais.adapter.Agent";

Property Adapter As dc.mais.adapter.Agent;

Parameter INVOCATION = "Queue";

Method Process(pRequest As dc.mais.messages.AgentRequest, Output oResponse As dc.mais.messages.AgentResponse) As %Status
{
    Set tSC = $$$OK
    
    Try {
        // Create response object
        Set oResponse = ##class(dc.mais.messages.AgentResponse).%New()
        
        // Call the adapter
        $$$ThrowOnError(..Adapter.GetAgentInstructions(.prompt))
        Set oResponse.Content = prompt
        Set oResponse.Tools = ..Adapter.Tools
    }
    Catch e {
        Set tSC = e.AsStatus()
        Set oResponse.Error = {"code":500, "message":($System.Status.GetOneErrorText(tSC))}.%ToJSON()
    }
    
    Quit tSC
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.mais.messages.AgentRequest">
        <Method>Process</Method>
    </MapItem>
</MapItems>
}

}
