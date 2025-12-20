/// Clears all items from the current order
Class dc.sample.operation.ClearOrder Extends Ens.BusinessOperation
{

Method Clear(pRequest As dc.sample.message.Request, Output pResponse As dc.sample.message.AddResponse) As %Status
{
    Set tSC = $$$OK
    Set pResponse = ##class(dc.sample.message.AddResponse).%New()
    Try {
        Do ##class(dc.sample.storage.Order).Clear()
        Set pResponse.Success = $$$YES
        Set pResponse.Message = "Order cleared"
    } Catch e {
        Set tSC = e.AsStatus()
        Set pResponse.Success = $$$NO
        Set pResponse.Message = {"code":500, "message":($System.Status.GetOneErrorText(tSC))}.%ToJSON()
    }
    Return tSC
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.sample.message.Request">
        <Method>Clear</Method>
    </MapItem>
</MapItems>
}

}
