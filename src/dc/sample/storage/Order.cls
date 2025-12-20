/// NOTE: This class is intended for tutorial purposes only.
/// It is a simple example and not suitable for production use.
/// If used for real applications, requirements gathering and proper data validation should be performed.
Class dc.sample.storage.Order Extends %RegisteredObject
{

ClassMethod Add(pOrder As %DynamicObject)
{
    Set ^currentOrder = $Increment(^currentOrder)
    Set ^currentOrder(^currentOrder) = pOrder.%ToJSON()
}

ClassMethod Clear()
{
    Kill ^currentOrder
}

ClassMethod Read() As %DynamicObject
{
    Set total = 0
    Set order = {"items": []}
    Set id = ""
    For {
        Set id=$Order(^currentOrder(id))
        Quit:(id="")
        Set current = {}.%FromJSON(^currentOrder(id))
        Set total = total + current."total_price"
        Do order.items.%Push(current)
    }
    Set order.total = $FNumber(total, ",", 2)
    Return order
}

}
