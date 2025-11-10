Class dc.mais.adapter.Agent Extends Ens.OutboundAdapter
{

/// Controls which properties are visible in Production settings
Parameter SETTINGS = "AgentName:Basic,AgentRole:Basic,AgentOutputInstructions:Basic:textarea?rows=5&cols=50,AgentTasks:Basic:textarea?rows=5&cols=50,AgentTools:Basic:textarea?rows=5&cols=50,MaxIterations,Verbose";

Property AgentName As %String;

/// agent background=["This assistant is knowledgeable, helpful, and suggests follow-up questions."],
Property AgentRole As %String;

Property AgentOutputInstructions As %String;

Property AgentTasks As %String;

Property AgentTools As %String;

// Comma-separated or JSON for extensibility

Property MaxIterations As %Integer [ InitialExpression = 3 ];

Property Verbose As %Boolean [ InitialExpression = 1 ];

/// Returns a %DynamicObject with agent persona, system prompt and tools
Method GetAgentInstructions(pRequest As dc.mais.messages.AgentRequest) As %DynamicObject
{
    // System prompt composition is honest and neutral, merges fields
    Set persona = ##class(%DynamicObject).%New()

    Set prompt = "You are "_..AgentName_" ("_..AgentRole_")."_$C(10)
    If ..AgentTasks '= "" {
        Set prompt = prompt_"Your tasks: "_..AgentTasks_$C(10)
    }
    If ..AgentTools '= "" {
        Set prompt = prompt_"Available tools: "_..AgentTools_$C(10)
    }
    Set prompt = prompt_"Be strictly honest and factual in your answers. Avoid any flattery or emotional language."
    Do persona.%Set("Name", ..AgentName)
    Do persona.%Set("Role", ..AgentRole)
    Do persona.%Set("tasks", ..AgentTasks)
    Do persona.%Set("Tools", ..AgentTools)
    Do persona.%Set("MaxIterations", ..MaxIterations)
    Do persona.%Set("Verbose", ..Verbose)

    Return persona
}

/// Optionally: Validates (or logs) any agent configuration issue
Method ValidateAgent() As %Status
{
    Set sc = $$$OK
    If ..AgentName = "" {
        $$$LOGWARNING("AgentName is empty. This may reduce persona clarity.")
    }
    If ..AgentRole = "" {
        $$$LOGWARNING("AgentRole is empty. Role context may be ambiguous.")
    }
    // Add more field-level checks here if needed.
    Quit sc
}

}
