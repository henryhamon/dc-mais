Class dc.mais.messages.ToolRequest Extends Ens.Request
{

/// The name of the tool requested by the LLM (e.g., "add_to_order", "get_menu")
Property ToolName As %String(MAXLEN = 100);

/// The arguments passed by the LLM in JSON String format
/// Example: {"item_name": "Coke", "quantity": 2}
Property Arguments As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolRequestDefaultData">
<Subscript>"ToolRequest"</Subscript>
<Value name="1">
<Value>ToolName</Value>
</Value>
<Value name="2">
<Value>Arguments</Value>
</Value>
</Data>
<DefaultData>ToolRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
