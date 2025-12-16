Include Ensemble

Class dc.mais.adapter.LLM Extends Ens.OutboundAdapter
{

/// Controls which properties are visible in the production settings UI
Parameter SETTINGS = "APIKeysConfig:Basic:textarea?rows=5&cols=50,BaseURL,Timeout,DefaultModel,MaxRetries,RetryDelay";

/// JSON configuration for API keys in LiteLLM format
/// Example:OPENAI_API_KEY,ANTHROPIC_API_KEY,COHERE_API_KEY
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

/// Python lib for OS interaction
Property os As %SYS.Python [ Private ];

/// Python lib for JSON handling
Property json As %SYS.Python [ Private ];

/// Python lib for interacting with LiteLLM services
Property litellm As %SYS.Python [ Private ];

Method OnInit() As %Status
{
    Set tSC = $$$OK
    Try {
        // Load Python libraries
        Set ..os = ##class(%SYS.Python).Import("os")
        Set ..json = ##class(%SYS.Python).Import("json")
        Set ..litellm = ##class(%SYS.Python).Import("litellm")
        
        // Set API keys from configuration
        If ..APIKeysConfig '= "" {
            Try {
                Set tKeyConfig = $ListFromString(..APIKeysConfig,",")
            } Catch(e) {
                Throw ##class(%Exception.General).%New("Error on parsing APIKeysConfig config. As this parameter expects a valid JSON, please check if the provided value is a valid one.")
            }
            Set pointer = 0
            While $ListNext(tKeyConfig, pointer, tKeyName) {
                Set credential = ##class(Ens.Config.Credentials).%OpenId(tKeyName)
                Continue:(credential="")
                Set tKeyValue = credential.PasswordGet()
                Do ..os.environ."__setitem__"(tKeyName, tKeyValue)
            }
        }
        
        $$$LOGINFO("LiteLLM Adapter initialized successfully")
    } Catch e {
        Set tSC = e.AsStatus()
        $$$LOGERROR("Failed to initialize LiteLLM Adapter: "_$System.Status.GetOneErrorText(tSC))
    }
    Quit tSC
}

Method GetLiteLLMInstance(pRequest As dc.mais.messages.LLMRequest) As %SYS.Python
{
    Return ..litellm
}

Method CallLiteLLM(pRequest As dc.mais.messages.LLMRequest, Output pResponse As dc.mais.messages.LLMResponse) As %Status
{
    Set tSC = $$$OK
    Set tAttempt = 0

    Set pResponse = ##class(dc.mais.messages.LLMResponse).%New()
    Set litellm = ..GetLiteLLMInstance(pRequest)
    
    While tAttempt <= ..MaxRetries {
        Set tAttempt = tAttempt + 1
        
        Try {
            // Call LiteLLM
            Set model = $Select(pRequest.Model '= "": pRequest.Model, 1: ..GetDefaultModel())
            Set json = [].%FromJSON(pRequest.History)
            Set:(json="") json = []
            Do json.%Push({"role": "user", "content": (pRequest.Content)})
            Do:(pRequest.UserContent'="") json.%Push({"role": "user", "content": (pRequest.UserContent)})
            Set messages = ..json.loads(json.%ToJSON())

            Set kwargs = {}.%New()
            Do kwargs.%Set("model", model)
            Do kwargs.%Set("messages", messages)
            
            If (pRequest.Parameter '= "") {
                Set toolsList = ..json.loads(pRequest.Parameter)
                Do kwargs.%Set("tools", toolsList)
                Do kwargs.%Set("tool_choice", "auto") 
                Do kwargs.%Set("drop_params", ##class(%SYS.Python).True()) 
            }
            Set tResponse = litellm.completion(kwargs...)
        
            // Map to our response object
            Set pResponse.Model = tResponse.model
            Set choices = []
            For i=0:1:tResponse.choices."__len__"()-1 {
                Do choices.%Push({}.%FromJSON(tResponse.choices."__getitem__"(0)."to_json"()))
            }
            Set pResponse.Choices = choices.%ToJSON()
            
            If (choices.%Size()>0) {
                Set choice = choices.%Get(choices.%Size()-1)
                If ($IsObject(choice.message)){
                    Set pResponse.Content = choice.message.content
                    Set:(choice.message."tool_calls" '="") pResponse.ToolCalls = choice.message."tool_calls".%ToJSON()
                    Set:(choice.message."function_call" '="") pResponse.FunctionCall = choice.message."function_call".%ToJSON()
                }
            }

            Set pResponse.Usage = {}.%FromJSON(tResponse.usage."to_json"()).%ToJSON()
            If ..hasattr(tResponse, "error") {
                Set pResponse.Error = {}.%FromJSON(tResponse.error."to_json"()).%ToJSON()
            }
        } Catch e {
            Set tSC = e.AsStatus()
            
            // Log the error
            $$$LOGERROR("LiteLLM call attempt "_tAttempt_" failed: "_$System.Status.GetOneErrorText(tSC))
            
            // If we've reached max retries, quit
            If tAttempt > ..MaxRetries Quit
            
            // Wait before retrying
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
    // If input starts with @, treat it as an environment variable reference
    If $Extract(input, 1, 1) = "@" {
        Set envVarName = $Extract(input, 2, *)
        If envVarName = "" {
            Throw ##class(%Exception.General).%New("Invalid environment variable ID")
        }
        Set envValue = ##class(%SYSTEM.Util).GetEnviron(envVarName)
        Return envValue
    }
    
    // Otherwise, treat as direct value
    Return input
}

}
