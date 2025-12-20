Class dc.sample.operation.GetOrder Extends Ens.BusinessOperation
{

/// Retrieves the current order contents with all items and total price
Method Get(pRequest As dc.sample.message.Request, Output pResponse As dc.sample.message.CurrentOrderResponse) As %Status
{
    Set tSC = $$$OK
    Set pResponse = ##class(dc.sample.message.CurrentOrderResponse).%New()
    Try {
        Set pResponse.Success = $$$YES
        Set order = ##class(dc.sample.storage.Order).Read()
        Set pResponse.Items = order.%ToJSON()
    } Catch e {
        Set tSC = e.AsStatus()
        Set pResponse.Success = $$$NO
        Set pResponse.Message = {"code":500, "message":($System.Status.GetOneErrorText(tSC))}.%ToJSON()
    }
    Quit tSC
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="dc.sample.message.Request">
        <Method>Get</Method>
    </MapItem>
</MapItems>
}

}
