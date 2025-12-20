Class dc.mais.adapter.Agent Extends Ens.OutboundAdapter
{

/// Controls which properties are visible in Production settings
Parameter SETTINGS = "Name:Basic,Role:Basic,Goal:Basic,Tasks:Basic:textarea?rows=5&cols=50,OutputInstructions:Basic:textarea?rows=5&cols=50,Tools:Basic:textarea?rows=5&cols=50,Target:Basic,Model:Basic,MaxIterations,Verbose";

/// Unique identifier for the agent
Property Name As %String;

/// Primary objective the agent is designed to achieve
Property Goal As %String(MAXLEN = 100);

/// Description of the agent's function and expertise. i.e. "This assistant is knowledgeable, helpful, and suggests follow-up questions."
Property Role As %String(MAXLEN = 350);

/// Guidelines for how the agent should format and present responses
Property OutputInstructions As %String(MAXLEN = 1000);

/// Ordered list of responsibilities and actions the agent must perform
Property Tasks As %String(MAXLEN = 1000);

/// List of callable functions available to the agent
Property Tools As %String(MAXLEN = 10000);

/// Name of the next agent in the workflow sequence (None if final agent)
Property Target As %String(MAXLEN = 1000);

// Comma-separated or JSON for extensibility

/// LLM model name (allows different agents to use different models)
Property Model As %String;

/// Maximum number of tool-calling iterations before stopping
Property MaxIterations As %Integer [ InitialExpression = 3 ];

/// Enable detailed logging of agent actions
Property Verbose As %Boolean [ InitialExpression = 1 ];

Method GetAgentInstructions(Output oPrompt As %String) As %String
{
    Set tSC = $$$OK
    Set oPrompt = "" // Garante que não é nulo
    Try {
        Set prompt = "You are "_..Name_", a specialized agent."_$C(10)
        Set:(..Role '= "") prompt = prompt_"## Your Role: "_..Role_$C(10)
        Set:(..Goal '= "") prompt = prompt_"## Your Goal: "_..Goal_$C(10)
        Set:(..Tasks '= "") prompt = prompt_"## Your Tasks: "_..Tasks_$C(10)
        Set:(..OutputInstructions'= "") prompt = prompt_"## Output Instructions: "_..OutputInstructions_$C(10)
        
        // Regras de Tools
        If (..Tools '= "") {
            Set prompt = prompt_"## Tool Usage Guidelines:"_$C(10)
            Set prompt = prompt_"- You have access to functions (tools) to get real data."_$C(10)
            Set prompt = prompt_"- You MUST call the function natively when needed."_$C(10)
            Set prompt = prompt_"- Do NOT guess or invent data. Use the function."_$C(10)
            Set prompt = prompt_"- NEVER write the function call JSON in the response text. Just trigger the function."_$C(10)
        }
        
        Set prompt = prompt_"# Remember: You are part of a multi-agent system."
        Set oPrompt = prompt
        
    } Catch ex {
        Set tSC=ex.AsStatus()
        $$$LOGERROR("Erro ao gerar instruções: "_ex.DisplayString())
    }
    Return tSC
}

/// Optionally: Validates (or logs) any agent configuration issue
Method ValidateAgent() As %Status
{
    Set sc = $$$OK
    If ..Name = "" {
        $$$LOGWARNING("Agent Name is empty. This may reduce persona clarity.")
    }
    If ..Role = "" {
        $$$LOGWARNING("Agent Role is empty. Role context may be ambiguous.")
    }
    // Add more field-level checks here if needed.
    Quit sc
}

/// Returns the complete list of tools (Specific + Handoff)
Method GetComputedTools() As %String
{
    // Default Handoff Tool Definition
    Set tHandoffTool = {
        "type": "function",
        "function": {
            "name": "handoff_to_agent",
            "description": "Transfer the conversation to another agent when you cannot handle the request or have finished your task.",
            "parameters": {
                "type": "object",
                "properties": {
                    "target_agent": {
                        "type": "string",
                        "description": "The target agent's name (e.g., 'OrderTaker', 'MenuExpert', 'OrderConfirmer')."
                    },
                    "reason": {
                        "type": "string",
                        "description": "The reason for transferring context."
                    }
                },
                "required": ["target_agent", "reason"]
            }
        }
    }

    // Initialize the Tools Array
    Set tToolsArray = []
    
    // If the agent already has tools configured, add them first
    If (..Tools '= "") {
        Try {
            Set tUserTools = [].%FromJSON(..Tools)
            Set iter = tUserTools.%GetIterator()
            While iter.%GetNext(.key, .val) {
                Do tToolsArray.%Push(val)
            }
        } Catch {
            // Fallback se for string mal formatada, logar erro ou ignorar
            $$$LOGWARNING("Erro ao parsear Tools do agente: "_..Name)
        }
    }

    // Add the Handoff Tool (Always)
    Do tToolsArray.%Push(tHandoffTool)

    Return tToolsArray.%ToJSON()
}

}
