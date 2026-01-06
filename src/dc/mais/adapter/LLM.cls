Include Ensemble

Class dc.mais.adapter.LLM Extends Ens.OutboundAdapter
{

/// Controls which properties are visible in the production settings UI
Parameter SETTINGS = "APIKeysConfig:Basic:textarea?rows=5&cols=50,BaseURL,Timeout,DefaultModel,MaxRetries,RetryDelay,PythonVersion:Basic";

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

/// Indicate which version should be used; ObjectScript is the default.
Property PythonVersion As %Boolean [ InitialExpression = 1 ];

/// Private properties for Python caches
Property os As %SYS.Python [ Private ];

Method OnInit() As %Status
{
    Set tSC = $$$OK
    Try {
        Do ..Initialize()
    } Catch e {
        Set tSC = e.AsStatus()
    }
    Quit tSC
}

/// Configure API Keys in Python Environment
Method Initialize() [ Language = python ]
{
    import os
    for tKeyName in self.APIKeysConfig.split(','): 
        credential = iris.cls("Ens.Config.Credentials")._OpenId(tKeyName.strip())
        if not credential:
            continue
        os.environ[tKeyName] = credential.PasswordGet()
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

Method CallLiteLLMObjectScript(pRequest As dc.mais.messages.LLMRequest, Output pResponse As dc.mais.messages.LLMResponse) As %Status
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

Method CallLiteLLM(pRequest As dc.mais.messages.LLMRequest) As dc.mais.messages.LLMResponse [ Language = python ]
{
    import litellm
    import json
    import time
    import iris

    t_attempt = 0
    max_retries = self.MaxRetries
    retry_delay = self.RetryDelay


    last_error = None
    pResponse = iris.cls("dc.mais.messages.LLMResponse")._New()

    while t_attempt <= max_retries:
        t_attempt += 1

        try:
            model = pRequest.Model
            if not model:
                model = self.GetDefaultModel()

            messages = [{"role": "user", "content": pRequest.Content}]
            
            if pRequest.UserContent:
                messages.append({"role": "user", "content": pRequest.UserContent})

            response = litellm.completion(model=model, messages=messages)

            pResponse.Model = response.model

            choices_list = []
            if hasattr(response, 'choices'):
                for choice in response.choices:
                    if hasattr(choice, 'model_dump'):
                        choices_list.append(choice.model_dump())
                    elif hasattr(choice, 'dict'):
                        choices_list.append(choice.dict())
                    else:
                        choices_list.append(dict(choice))
            
            pResponse.Choices = json.dumps(choices_list)
            if (len(response.choices) > 0 ):
                pResponse.Content = response.choices[0].message.content

            if hasattr(response, 'usage'):
                if hasattr(response.usage, 'model_dump'):
                    pResponse.Usage = json.dumps(response.usage.model_dump())
                else:
                    pResponse.Usage = json.dumps(dict(response.usage))

            if hasattr(response, 'error') and response.error:
                pResponse.Error = json.dumps(dict(response.error))

            return pResponse

        except Exception as e:
            last_error = str(e)
            
            class_name = "dc.mais.adapter.LiteLLM"
            iris.cls("Ens.Util.Log").LogError(class_name, "CallLiteLLM", f"LiteLLM call attempt {t_attempt} failed: {last_error}")

            if t_attempt > max_retries:
                break

            time.sleep(retry_delay)

    error_payload = {
        "message": "All LiteLLM call attempts failed",
        "details": last_error
    }
    pResponse.Error = json.dumps(error_payload)

    return pResponse
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
