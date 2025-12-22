Include Ensemble

Class dc.mais.adapter.LLM Extends Ens.OutboundAdapter
{

/// Controls which properties are visible in the production settings UI
Parameter SETTINGS = "APIKeysConfig:Basic:textarea?rows=5&cols=50,BaseURL,Timeout,DefaultModel,MaxRetries,RetryDelay";

/// JSON configuration for API keys in Production.Credentials
/// Example: ["OPENAI_API_KEY","ANTHROPIC_API_KEY"]
Property APIKeysConfig As %String(MAXLEN = "");

/// Base URL for LiteLLM API (optional - for proxy mode)
Property BaseURL As %String;

/// Timeout for API calls (in seconds)
Property Timeout As %Numeric [ InitialExpression = 30 ];

/// Default model to use if not specified in request
Property DefaultModel As %String [ InitialExpression = "o4-mini" ];

/// Maximum retry attempts for failed calls
Property MaxRetries As %Integer [ InitialExpression = 0 ];

/// Retry delay in seconds between attempts
Property RetryDelay As %Numeric [ InitialExpression = 1 ];

/// Private properties for Python caches
Property os As %SYS.Python [ Private ];

Method OnInit() As %Status
{
    Set tSC = $$$OK
    Try {
        // Initialize basic libraries
        Set ..os = ##class(%SYS.Python).Import("os")
        
        // Configure API Keys in Python Environment
        If ..APIKeysConfig '= "" {
            Set tKeyConfig = $ListFromString(..APIKeysConfig,",")
            Set pointer = 0
            While $ListNext(tKeyConfig, pointer, tKeyName) {
                Set credential = ##class(Ens.Config.Credentials).%OpenId(tKeyName)
                Continue:(credential="")
                Do ..os.environ."__setitem__"(tKeyName, credential.PasswordGet())
            }
        }
    } Catch e {
        Set tSC = e.AsStatus()
    }
    Quit tSC
}

/// Helper method in pure Python
/// This resolves the issue of passing **kwargs from IRIS to Python safely
ClassMethod PyCompletion(model As %String, messagesJson As %String, toolsJson As %String, dropParams As %Boolean) As %SYS.Python [ Language = python ]
{
    import litellm
    import json
    
    # 1. Decode messages from JSON string to Python List
    msgs = json.loads(messagesJson)
    
    # 2. Build arguments dictionary
    kwargs = {
        "model": model,
        "messages": msgs
    }
    
    # 3. If tools exist, add to dictionary
    if toolsJson and toolsJson.strip() != "":
        kwargs["tools"] = json.loads(toolsJson)
        kwargs["tool_choice"] = "auto"
    
    # 4. Handle Azure and extra parameters
    if dropParams:
        kwargs["drop_params"] = True
        
    # 5. Execute call using unpacking (**kwargs)
    return litellm.completion(**kwargs)
}

Method CallLiteLLM(pRequest As dc.mais.messages.LLMRequest, Output pResponse As dc.mais.messages.LLMResponse) As %Status
{
    Set tSC = $$$OK
    Set tAttempt = 0
    Set pResponse = ##class(dc.mais.messages.LLMResponse).%New()
    
    While tAttempt <= ..MaxRetries {
        Set tAttempt = tAttempt + 1
        
        Try {
            Set model = $Select(pRequest.Model '= "": pRequest.Model, 1: ..GetDefaultModel())
            
            // Prepare History
            Set jsonHistory = [].%FromJSON(pRequest.History)
            Set:(jsonHistory="") jsonHistory = []
            
            // Inject Tool Output if present (Close the Loop logic)
            If (pRequest.ToolCallId '= "") && (pRequest.ToolOutput '= "") {
                Set tToolMsg = {}
                Set tToolMsg.role = "tool"
                Set tToolMsg.content = pRequest.ToolOutput
                Set tToolMsg."tool_call_id" = pRequest.ToolCallId
                Do jsonHistory.%Push(tToolMsg)
            }
            
            // Add current user content/prompt only if not empty
            If (pRequest.Content '= "") {
                Do jsonHistory.%Push({"role": "user", "content": (pRequest.Content)})
            }
            
            // Add extra user content field if present
            If (pRequest.UserContent'="") {
                Do jsonHistory.%Push({"role": "user", "content": (pRequest.UserContent)})
            }
            
            Set strMessages = jsonHistory.%ToJSON()

            // Call Python Helper
            Set tResponse = ..PyCompletion(model, strMessages, pRequest.Parameter, 1)
        
            // Map Response
            Set pResponse.Model = tResponse.model
            
            // Convert Python choices to IRIS DynamicArray
            Set choices = []
            For i=0:1:tResponse.choices."__len__"()-1 {
                Do choices.%Push({}.%FromJSON(tResponse.choices."__getitem__"(i)."to_json"()))
            }
            Set pResponse.Choices = choices.%ToJSON()
            
            // Process the last choice
            If (choices.%Size()>0) {
                Set choice = choices.%Get(choices.%Size()-1)
                
                If ($IsObject(choice.message)){
                    Set pResponse.Content = choice.message.content
                    
                    // Extract Tool Calls
                    // Check if 'tool_calls' exists and is a valid Object (DynamicArray)
                    Set tToolCalls = choice.message."tool_calls"
                    
                    // Verify it is an Object (Array) and not empty string
                    If $IsObject(tToolCalls) {
                        Do ..GetToolCalls(tToolCalls, .pResponse)
                    }
                }
            }

            // Map Usage
            If ..hasattr(tResponse, "usage") {
                Set pResponse.Usage = {}.%FromJSON(tResponse.usage."to_json"()).%ToJSON()
            }
            
            // Success - Exit Loop
            Quit 

        } Catch e {
            Set tSC = e.AsStatus()
            $$$LOGERROR("LiteLLM call attempt "_tAttempt_" failed: "_$System.Status.GetOneErrorText(tSC))
            If tAttempt > ..MaxRetries Quit
            Hang ..RetryDelay
        }
    }
    
    If ($$$ISERR(tSC)) {
        Set pResponse.Error = {
            "message": "All LiteLLM call attempts failed",
            "details": ($System.Status.GetOneErrorText(tSC))
        }.%ToJSON()
    }
    Quit tSC
}

ClassMethod hasattr(obj As %SYS.Python, attr As %String) [ Language = python ]
{
    return hasattr(obj, attr)
}

Method GetDefaultModel() As %String
{
    Return ..ResolveModelValue(..DefaultModel)
}

ClassMethod ResolveModelValue(input As %String) As %String
{
    If $Extract(input, 1, 1) = "@" {
        Set envVarName = $Extract(input, 2, *)
        Return ##class(%SYSTEM.Util).GetEnviron(envVarName)
    }
    Return input
}

/// Helper to extract tools from IRIS DynamicArray and populate Response String
ClassMethod GetToolCalls(pToolCalls As %DynamicArray, ByRef pResponse As dc.mais.messages.LLMResponse) As %Status
{
    Set tSC = $$$OK
    Try {
        // Since LLMResponse.ToolCalls is now a %String, we simply assign the JSON
        // This is exactly what the BPL Orchestrator expects to parse with [].%FromJSON()
        Set pResponse.ToolCalls = pToolCalls.%ToJSON()
        
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    Return tSC
}

}
