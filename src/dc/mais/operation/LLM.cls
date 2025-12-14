Class dc.mais.operation.LLM Extends Ens.BusinessOperation
{

Parameter ADAPTER = "dc.mais.adapter.LLM";

Property Adapter As dc.mais.adapter.LLM;

Parameter INVOCATION = "Queue";

/// Call LLM using LiteLLM-compatible messages via the adapter
Method CallLiteLLM(pRequest As dc.mais.messages.LLMRequest, Output oResponse As dc.mais.messages.LLMResponse) As %Status
{
    Set tSC = $$$OK
    Try {
        // Create response object
        Set oResponse = ##class(dc.mais.messages.LLMResponse).%New()
        
        // Call the adapter
        Set tSC = ..Adapter.CallLiteLLM(pRequest, .oResponse)
        If $$$ISERR(tSC) Quit
    }
    Catch ex {
        Set tSC = ex.AsStatus()
        Set oResponse.Error = {"code":500, "message":($System.Status.GetOneErrorText(tSC))}.%ToJSON()
    }
    Return tSC
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
