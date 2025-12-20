Class dc.sample.operation.Menu Extends Ens.BusinessOperation
{

Method GetMenu(pRequest As dc.sample.message.Request, Output pResponse As dc.sample.message.MenuResponse) As %Status
{
    Set tSC = $$$OK
    
    Try {
        // Create response object
        Set pResponse = ##class(dc.sample.message.MenuResponse).%New()
        Set menu = ##class(dc.sample.storage.Menu).Get()
        Set pResponse.Menu = menu.%ToJSON()
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
    <MapItem MessageType="dc.sample.message.Request">
        <Method>GetMenu</Method>
    </MapItem>
</MapItems>
}

}
