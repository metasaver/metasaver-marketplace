# Claude Code Building Blocks Reference

This document provides detailed definitions of all Claude Code extensibility mechanisms. Use this reference when you need to understand specific characteristics or capabilities of each building block.

## Skills

**Definition:** Folders containing instructions, scripts, and resources that Claude dynamically discovers and loads when relevant to a task.

**Key Characteristics:**
- Use progressive disclosure: metadata loads first (~100 tokens), full instructions load when needed (<5k tokens)
- Files and scripts load only as required
- Persist across conversations
- Can include code and assets
- Discovered dynamically based on relevance

**Structure:**
```
skill-name/
├── SKILL.md (required - frontmatter + instructions)
├── scripts/ (optional - executable code)
├── references/ (optional - documentation)
└── assets/ (optional - templates, images, etc.)
```

**Best For:**
- Organizational workflows (brand guidelines, compliance procedures, templates)
- Domain expertise (Excel formulas, PDF manipulation, data analysis)
- Personal preferences (note-taking systems, coding patterns, research methods)
- Repeated workflows across multiple conversations
- Teaching Claude procedural knowledge

**Example:** "A brand guidelines skill that includes your company's color palette, typography rules, and layout specifications"

---

## Prompts

**Definition:** Natural language instructions provided to Claude during conversation; ephemeral and conversational in nature.

**Key Characteristics:**
- Reactive and immediate
- Single-conversation persistence
- No code inclusion
- Require repeated input for similar tasks
- Ideal for interactive refinement

**Best For:**
- One-off requests and quick tasks
- Conversational refinement and iteration
- Immediate context and ad-hoc instructions
- Interactive dialogue-based workflows
- Exploratory tasks without established patterns

**Rule of Thumb:** If you find yourself typing the same prompt repeatedly across conversations, convert it to a skill for consistency and efficiency.

---

## Subagents

**Definition:** Specialized AI assistants with independent context windows, custom system prompts, and specific tool permissions; available in Claude Code and the Claude Agent SDK.

**Key Characteristics:**
- Operate independently with their own configuration
- Handle discrete tasks and return results to main agent
- Support parallel processing
- Enable tool restriction and context isolation
- Can be invoked programmatically
- Stateless - each invocation is independent

**Structure:**
```
.claude/agents/
└── agent-name.md (frontmatter + system prompt + capabilities)
```

**Best For:**
- Task specialization (code review, test generation, security audits)
- Context management and focused conversations
- Parallel task execution
- Limiting specific operations (read-only access, restricted permissions)
- Complex multi-step workflows requiring coordination
- Domain-specific expertise with dedicated context

**Subagents vs. Skills:** Use subagents for independent task execution with specific tool access; use skills to teach expertise that any agent can apply.

---

## Model Context Protocol (MCP)

**Definition:** An open standard for connecting AI assistants to external systems where data lives—repositories, business tools, databases, and development environments.

**Key Characteristics:**
- Provides universal connection layer
- Standardized protocol across integrations
- MCP servers expose data; MCP clients connect to servers
- Persistent connections with automatic updates
- Runs as separate processes
- Provides tools and resources

**Best For:**
- Accessing external data (Google Drive, Slack, GitHub, databases)
- Connecting business tools (CRM, project management platforms)
- Integrating development environments (local files, IDEs, version control)
- Linking custom proprietary systems
- Real-time data access
- Bidirectional communication with external services

**MCP vs. Skills:** MCP connects Claude to data; skills teach Claude what to do with that data. Use both together for comprehensive workflows.

---

## Hooks

**Definition:** Shell commands that execute automatically in response to specific events in Claude Code (e.g., before tool calls, after edits, on user prompt submit).

**Key Characteristics:**
- Event-driven automation
- Execute synchronously or asynchronously
- Can block or modify operations
- Configured in Claude Code settings
- Run shell commands/scripts
- Access to event context via environment variables

**Hook Types:**
- `user-prompt-submit` - Before user message is sent
- `tool-call` - Before/after tool execution
- `file-edit` - Before/after file modifications
- `session-start` - When Claude Code session starts
- `session-end` - When session ends

**Best For:**
- Automated validation (linting, type checking)
- Pre-commit checks
- Automatic formatting
- Logging and monitoring
- Security checks
- Build automation
- Git operations (commit, push)

**Hooks vs. Skills:** Hooks automate actions at specific events; skills teach Claude how to perform tasks when asked.

---

## Templates

**Definition:** Pre-formatted content patterns or boilerplate structures that can be reused across different contexts.

**Key Characteristics:**
- Static or parameterized content
- Can be files, code snippets, or document structures
- Often stored in skill assets
- Reusable across multiple uses
- May include placeholder variables

**Template Storage Options:**
1. **In Skills:** Store as `assets/` for skill-specific templates
2. **In MCP Resources:** Expose via MCP server for external templates
3. **In Memory Files:** For project-specific patterns

**Best For:**
- Standard document formats
- Boilerplate code structures
- Configuration file patterns
- Email/communication templates
- Report formats
- Project scaffolding

**Templates vs. Skills:** Templates provide content structure; skills provide the intelligence to use and customize templates appropriately.

---

## Projects (claude.ai only)

**Definition:** Self-contained workspaces with separate chat histories, knowledge bases, and custom instructions; available on all paid Claude plans.

**Key Characteristics:**
- Include 200K context window
- Support document uploads and knowledge bases
- Enable Retrieval Augmented Generation (RAG) mode
- Workspace organization and team collaboration (Team/Enterprise plans)
- Persistent context across conversations within the project

**Best For:**
- Persistent background knowledge needed across conversations
- Workspace separation for different initiatives
- Team collaboration with shared knowledge
- Project-specific tone, perspective, or approach
- Large document collections

**Note:** Projects are available on claude.ai web interface, not in Claude Code.

---

## Comparison Matrix

| Feature | Skills | Prompts | Subagents | MCP | Hooks | Templates |
|---------|--------|---------|-----------|-----|-------|-----------|
| **Persistence** | Across conversations | Single conversation | Across sessions | Continuous | Per-session config | Reusable |
| **Contains** | Instructions + code + assets | Natural language | Full agent logic | Tool definitions | Shell commands | Content structure |
| **Loading** | Dynamically as needed | Each turn | When invoked | Always available | Event-triggered | On-demand |
| **Code Support** | Yes | No | Yes | Yes | Yes | Yes |
| **Automation** | No | No | No | No | Yes | No |
| **External Data** | No | No | No | Yes | No | No |

---

## Integration Strategy

These components work synergistically. A comprehensive workflow might:

1. Use **MCP** to connect to external data sources (GitHub, databases, Slack)
2. Activate **Skills** for specialized knowledge and procedural workflows
3. Deploy **Subagents** for parallel specialized analysis
4. Trigger **Hooks** for automated validation and checks
5. Apply **Templates** for consistent output formatting
6. Refine results through conversational **Prompts**

This layered approach combines persistent context, external data access, specialized expertise, independent task execution, automation, and interactive guidance into sophisticated workflows.
