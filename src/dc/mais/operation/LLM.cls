Class dc.mais.operation.LLM Extends Ens.BusinessOperation
{

Parameter ADAPTER = "dc.mais.adapter.LLM";

Property Adapter As dc.mais.adapter.LLM;

Parameter INVOCATION = "Queue";

/// Call LLM using LiteLLM-compatible messages via the adapter
Method CallLiteLLM(pRequest As dc.mais.messages.LLMRequest, Output pResponse As dc.mais.messages.LLMResponse) As %Status
{
    Set tSC = $$$OK
    
    Try {
        // Create response object
        Set pResponse = ##class(dc.mais.messages.LLMResponse).%New()
        
        // Call the adapter
        Set tSC = ..Adapter.CallLiteLLM(pRequest, .pResponse)
        If $$$ISERR(tSC) Quit
    }
    Catch e {
        Set tSC = e.AsStatus()
        Set pResponse.Error = {"code":500, "message":($System.Status.GetOneErrorText(tSC))}.%ToJSON()
    }
    
    Quit tSC
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.mais.messages.LLMRequest">
        <Method>CallLiteLLM</Method>
    </MapItem>
</MapItems>
}

}
