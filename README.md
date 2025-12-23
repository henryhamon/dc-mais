 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/intersystems-iris-dev-template)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)

# dc-mais – Multi-Agent Interoperability System for InterSystems IRIS

## 📖 Overview

> **Note:** This project is a practical example that accompanies an article about AI agents.

**dc-mais** is a micro framework for building **Stateful Multi-Agent Systems** within **InterSystems IRIS**.

It leverages the power of **Business Process Language (BPL)** to visually orchestrate AI agents, managing conversation state, short-term memory, and complex handoff protocols between specialized agents (personas) natively.

This project is designed to bridge the gap between ephemeral Python-based AI scripts and enterprise-grade process orchestration.

**dc-mais** provides:

* **The Engine:** An abstract BPL Orchestrator that manages the "ReAct" (Reason + Act) loop and conversation history.
* **The Adapter:** A configurable `Agent` adapter to define personas (Role, Goal, Tasks) and strictly control routing (Guided Handoff).
* **The Architecture:** A pattern to separate the *Engine* (framework) from your *Business Logic* (Agent Routers and Tool Runners).

## 🎯 Motivation

Building reliable AI agents often involves complex boilerplate code for state management, tool execution, and debugging. Pure Python frameworks can feel like "black boxes" when deployed in production.

**dc-mais** changes this paradigm by facilitating agent development through **Visual Orchestration**:

* **Low-Code Development with BPL:** Instead of writing complex loops in code, you define your agent's thought process and routing logic using **Business Process Language (BPL)**, a visual and intuitive low-code tool.
* **Enterprise Interoperability:** It extracts the full power of InterSystems IRIS to seamlessly connect your AI agents with existing business operations, databases, and APIs.
* **Unmatched Traceability:** **dc-mais** leverages the native **Visual Trace**, allowing you to audit every step of the agent's reasoning, tool usage, and data exchange in a graphical, easy-to-understand interface.

## ⚙️ How It Works

The framework operates on a **Double Loop Architecture**:

### 1. The Persona (`dc.mais.adapter.Agent`)

Agents are not just prompts; they are configured components. You define:

* **Role & Goal:** The agent's specific purpose.
* **Tasks:** What they are allowed to do.
* **Target:** A strict "Allow List" of other agents they can hand off to.

The framework automatically injects a native tool called `handoff_to_agent`, allowing the LLM to request a transfer when it finishes its task.

### 2. The Engine (`dc.mais.engine.Orchestrator`)

This is the brain of the operation. It abstracts the complexity of the AI loop:

* **Conversation Flow (Outer Loop):** Determines *who* is speaking based on the current target.
* **ReAct Loop (Inner Loop):** Executes the "Think -> Act -> Observe" cycle. If the AI requests a tool, the engine pauses, executes it, and feeds the result back.

### 3. The Implementation (Strategy Pattern)

To keep the engine generic, you implement two simple BPLs in your namespace:

* **AgentRouter:** Receives a target name (e.g., "order_taker") and routes it to the correct Business Operation.
* **ToolRunner:** Receives a tool name (e.g., "add_to_order") and executes the specific ObjectScript logic.

---

## 🚀 Installation with IPM

```
zpm:USER>install dc-mais

```

## 🛠️ Installation with Docker

The backend is containerized for easy setup. Follow these steps to get it running.

1. **Clone the repository:**
```bash
git clone https://github.com/henryhamon/dc-mais.git
cd dc-mais

```


2. **Build the Docker container:**
This command builds the necessary images for the application.
```bash
docker-compose build --no-cache --progress=plain

```


3. **Start the application:**
This command starts the services in detached mode (`-d`).
```bash
docker-compose up -d

```


4. **Stop and remove containers (when done):**
To stop the application and remove all associated containers, networks, and volumes.
```bash
docker-compose down --rmi all

```



---

## 💡 Usage Examples

### 1. Defining an Agent in Production

Configure your agents in the interoperability production. Here is an example of a **MenuExpert**:

```xml
<Item Name="Agent.MenuExpert" ClassName="dc.mais.operation.Agent">
    <Setting Name="Role">Expert on French cuisine and wine pairings.</Setting>
    <Setting Name="Goal">Help customers choose the perfect dish.</Setting>
    <Setting Name="Tasks">
        - Explain menu items enthusiastically.
        - Suggest pairings.
        - CRITICAL: If the user wants to order, handoff to OrderTaker immediately.
    </Setting>
    <Setting Name="Target">order_taker</Setting> </Item>

```

### 2. Implementing the Router

Create a simple BPL (`AgentRouter`) to map the strings used by the Engine to your Agent Operations:

```xml
<switch name='Route Agent'>
    <case condition='request.TargetAgent="menu_expert"'>
        <call target='Agent.MenuExpert' ... />
    </case>
    <case condition='request.TargetAgent="order_taker"'>
        <call target='Agent.OrderTaker' ... />
    </case>
</switch>

```

### 3. Visual Trace Debugging

Once running, you can inspect the entire thought process of your multi-agent system.

*(Note: Visual Trace shows the Engine calling the Router, the Agent thinking, calling the ToolRunner, and receiving the result.)*

---

## 🔍 Limitations

* **LLM Dependency:** Requires access to an LLM provider (OpenAI, Azure, Bedrock) via API keys.
* **State Scope:** Context history is persisted for the duration of the BPL session. Long-term memory (Vector DB) integration is planned for future releases.

---

## 🙌 Credits

> dc-mais is developed with ❤️ by
> [Henry Pereira](https://community.intersystems.com/user/henry-pereira)