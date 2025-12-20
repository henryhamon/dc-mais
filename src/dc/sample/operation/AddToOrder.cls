Class dc.sample.operation.AddToOrder Extends Ens.BusinessOperation
{

/// Adds an item to the customer's order with optional extras and special requests
Method Add(pRequest As dc.sample.message.AddRequest, Output pResponse As dc.sample.message.AddResponse) As %Status
{
    Set tSC = $$$OK
    Set pResponse = ##class(dc.sample.message.AddResponse).%New()
    Try {
        Set order = {
            "item": "",
            "price": "",
            "extras": "",
            "quantity": "",
            "special_requests": "",
            "total_price": ""
        }
        Set extraCost = 0
        Set pResponse.Success = $$$NO
        Set menu = ##class(dc.sample.storage.Menu).Get()
        Set categories = ["appetizers", "main_courses", "desserts", "beverages", "extras"]
        Set catIt = categories.%GetIterator()
        While catIt.%GetNext(.ctK, .category) {
            Set items = menu.%Get(category)
            Continue:(items="")
            Set itIt = items.%GetIterator()
            While itIt.%GetNext(.itK, .item) {
                If ($ZCONVERT(item.name,"l") = $ZCONVERT(pRequest.ItemName,"l")) {
                    Set:(category'="extras") order.item = item.name,
                        order.price = item.price,
                        order.quantity = pRequest.Quantity
                }
                If ($ZCONVERT(item.name,"l") = $ZCONVERT(pRequest.Extras,"l")) {
                    Set:(category="extras") extraCost = item.price, 
                        order.extras = item.name
                }
            }
        }
        If (order.quantity'="") {
            Set order."total_price" = ((order.price + extraCost) * order.quantity)
            Do ##class(dc.sample.storage.Order).Add(order)
            Set pResponse.Success = $$$YES
            Set pResponse.Message = "Added "_pRequest.Quantity_" x "_pRequest.ItemName_" to order"
            Set pResponse.Item = pRequest.ItemName
        }
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
    <MapItem MessageType="dc.sample.message.AddRequest">
        <Method>Add</Method>
    </MapItem>
</MapItems>
}

}
