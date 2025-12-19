Class dc.mais.messages.LLMResponse Extends (Ens.Response, %JSON.Adaptor, %XML.Adaptor)
{

/// The model used for generation
Property Model As %String(MAXLEN = 100);

/// The generated completions (JSON string)
Property Choices As %String(MAXLEN = "");

/// Content returned (JSON string)
Property Content As %String(MAXLEN = "");

Property ToolCalls As %String(%JSONFIELDNAME = "tool_calls_raw", MAXLEN = "");

// Property ToolCalls As list Of dc.mais.messages.FunctionCall(%JSONFIELDNAME = "tool_calls");

/// Tools (JSON string)
/// Token usage statistics (JSON string)
Property Usage As %String(MAXLEN = "");

/// Error information if the call failed (JSON string)
Property Error As %String(MAXLEN = "");

/// Helper method to get the first completion text
Method GetFirstCompletion() As %String
{
    Try {
        If ..Choices = "" {
            Return ""
        }
        
        Set tChoices = [].%FromJSON(..Choices)
        If tChoices.%Size() > 0 {
            Return tChoices.%Get(0).message.content
        }
        Return ""
    }
    Catch e {
        Return ""
    }
}

Storage Default
{
<Data name="LLMResponseDefaultData">
<Subscript>"LLMResponse"</Subscript>
<Value name="1">
<Value>Model</Value>
</Value>
<Value name="2">
<Value>Choices</Value>
</Value>
<Value name="3">
<Value>Content</Value>
</Value>
<Value name="4">
<Value>ToolCalls</Value>
</Value>
<Value name="5">
<Value>Usage</Value>
</Value>
<Value name="6">
<Value>Error</Value>
</Value>
</Data>
<DefaultData>LLMResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
