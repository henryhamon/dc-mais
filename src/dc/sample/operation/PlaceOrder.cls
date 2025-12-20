Class dc.sample.operation.PlaceOrder Extends Ens.BusinessOperation
{

Method PlaceOrder(pRequest As dc.sample.message.PlaceOrderRequest, Output pResponse As dc.sample.message.PlaceOrderResponse) As %Status
{
    Set tSC = $$$OK
    Set pResponse = ##class(dc.sample.message.PlaceOrderResponse).%New()
    Try {
        Set pResponse.Success = $$$YES
        Set order = ##class(dc.sample.storage.Order).Read()
        Set:(pRequest.TableNumber="") pRequest.TableNumber = $R(10)
        Set pResponse.TableNumber = pRequest.TableNumber
        Set pResponse.Items = order.items.%ToJSON()
        Set pResponse.EstimatedTime = "25-30 minutes"
        Set pResponse.Message = "Order "_$R(99)_$R(99)_$R(99)_" sent to the kitchen! Total: "_order.total
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
    <MapItem MessageType="dc.sample.message.PlaceOrderRequest">
        <Method>PlaceOrder</Method>
    </MapItem>
</MapItems>
}

}
