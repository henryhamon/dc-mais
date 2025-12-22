/// 
Class dc.sample.process.ToolRunner Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='dc.mais.messages.ToolRequest' response='dc.mais.messages.ToolResponse' height='2000' width='2015' >
<context>
<property name='Target' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='250' />
</parameters>
</property>
<property name='Arguments' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='25000' />
</parameters>
</property>
<property name='ToolResult' type='%String' initialexpression='""' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='25000' />
</parameters>
</property>
</context>
<sequence xend='200' yend='1000' >
<assign name="Set Target" property="context.Target" value="request.ToolName" action="set" languageOverride="" xpos='200' ypos='250' />
<switch name='Select Tool' xpos='200' ypos='350' xend='200' yend='800' >
<case condition='context.Target="get_menu"' name='Get Menu' >
<call name='GetMenu Tool' target='Tool.GetMenu' async='0' xpos='335' ypos='500' >
<request type='dc.sample.message.Request' />
<response type='dc.sample.message.MenuResponse' >
<assign property="context.ToolResult" value="callresponse.Menu" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='GetMenu Tool' type='all' xpos='335' ypos='600' />
</case>
<case condition='context.Target="get_order"' name='Get Order' >
<call name='Get Order Tool' target='Tool.GetOrder' async='0' xpos='605' ypos='500' >
<request type='dc.sample.message.Request' />
<response type='dc.sample.message.CurrentOrderResponse' >
<assign property="context.ToolResult" value="callresponse.Items" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='Get Order Tool' type='all' xpos='605' ypos='600' />
</case>
<case condition='context.Target="place_order"' name='Place Order' >
<call name='Place Order Tool' target='Tool.PlaceOrder' async='0' xpos='875' ypos='500' >
<request type='dc.sample.message.PlaceOrderRequest' >
<assign property="callrequest.TableNumber" value="context.TableNumber" action="set" languageOverride="" />
</request>
<response type='dc.sample.message.PlaceOrderResponse' >
<assign property="context.ToolResult" value="callresponse.Message" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='Place Order Tool' type='all' xpos='875' ypos='600' />
</case>
<case condition='context.Target="clear_order"' name='Clear Order' >
<call name='Clear Order Tool' target='Tool.ClearOrder' async='0' xpos='1145' ypos='500' >
<request type='dc.sample.message.Request' />
<response type='dc.sample.message.AddResponse' >
<assign property="context.ToolResult" value="callresponse.Item" action="set" languageOverride="" />
</response>
</call>
<sync name='Wait' calls='Clear Order Tool' type='all' xpos='1145' ypos='600' />
</case>
<case condition='context.Target="add_to_order"' name='Add to Order' >
<code name='Extract Order Args' xpos='1415' ypos='500' >
<![CDATA[
    Try {
        
        Set tArgsJson = {}.%FromJSON(context.Arguments).%Get(0).function.arguments
        Set tArgs = {}.%FromJSON(tArgsJson)
        
        Set context.OrderItemName = tArgs."item_name"
        Set context.OrderExtras = tArgs."extras"
        Set context.OrderSpecialRequests = tArgs."special_requests"
        
        
        If (tArgs."quantity" = "") || (tArgs."quantity" <= 0) { 
            Set context.OrderQuantity = 1 
        } Else { 
            Set context.OrderQuantity = tArgs."quantity" 
        }
    } Catch e {
        $$$LOGERROR("Erro ao extrair argumentos do pedido: " _ e.DisplayString())
    }]]>
</code>
<call name='Add to Order' target='Tool.AddToOrder' async='0' xpos='1415' ypos='600' >
<request type='dc.sample.message.AddRequest' >
<assign property="callrequest.ItemName" value="context.OrderItemName" action="set" languageOverride="" />
<assign property="callrequest.Extras" value="context.OrderExtras" action="set" languageOverride="" />
<assign property="callrequest.SpecialRequests" value="context.OrderSpecialRequests" action="set" languageOverride="" />
<assign property="callrequest.Quantity" value="context.OrderQuantity" action="set" languageOverride="" />
</request>
</call>
<sync name='Wait' calls='Add to Order' type='all' xpos='1415' ypos='700' />
</case>
<default name='default' />
</switch>
<assign name="Set Result" property="response.Result" value="context.ToolResult" action="set" languageOverride="" xpos='200' ypos='900' />
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
