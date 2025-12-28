# SS Command Target State

Target workflow architecture for the `/ss` (Screenshot) command.

**Purpose:** Analyze screenshots saved to `~/.screenshots/latest.png`, process user instructions, and optionally route to /ms for implementation.

---

## 1. High-Level Flow Overview

```mermaid
flowchart TB
    subgraph Entry["1. Entry Point"]
        A["/ss {instructions}"]
    end

    subgraph Acknowledge["2. Acknowledge"]
        B["Confirm screenshot location:<br/>~/.screenshots/latest.png"]
    end

    subgraph Read["3. Read Image"]
        C["Read tool:<br/>~/.screenshots/latest.png"]
        D["Image presented visually<br/>(multimodal)"]
    end

    subgraph Process["4. Process Instructions"]
        E{"Instruction Type?"}
        E1["UI Analysis"]
        E2["Text Extraction"]
        E3["Debug Visual"]
        E4["Design Check"]
        E5["Code Generation"]
    end

    subgraph Output["5. Output"]
        F["Provide response based on<br/>screenshot + instructions"]
    end

    subgraph Route["6. Route to /ms (Optional)"]
        R{"Implementation<br/>Needed?"}
        R1["Extract requirements<br/>as text prompt"]
        R2["Route to /ms<br/>for implementation"]
    end

    A --> B --> C --> D --> E
    E --> E1 & E2 & E3 & E4 & E5
    E1 & E2 & E3 & E4 & E5 --> F
    F --> R
    R -->|"No"| END((Done))
    R -->|"Yes"| R1 --> R2
```

---

## 2. Instruction Types

```mermaid
flowchart LR
    subgraph Types["Instruction Categories"]
        T1["🎨 UI Analysis"]
        T2["📝 Text Extraction"]
        T3["🐛 Debug Visual"]
        T4["✅ Design Check"]
        T5["💻 Code Generation"]
    end

    subgraph Actions["Resulting Actions"]
        A1["- Review layout<br/>- Check spacing<br/>- Analyze colors<br/>- Suggest improvements"]
        A2["- OCR extraction<br/>- Structure text<br/>- Create markdown"]
        A3["- Identify issues<br/>- CSS problems<br/>- Alignment bugs<br/>- Provide fix"]
        A4["- Compare to specs<br/>- Check Tailwind<br/>- Verify patterns"]
        A5["- Recreate UI<br/>- React components<br/>- HTML/CSS"]
    end

    T1 --> A1
    T2 --> A2
    T3 --> A3
    T4 --> A4
    T5 --> A5
```

---

## 3. Simple Sequence

```mermaid
sequenceDiagram
    participant U as User
    participant SS as /ss
    participant R as Read Tool

    U->>SS: /ss analyze this modal
    SS->>SS: Acknowledge ~/.screenshots/latest.png
    SS->>R: Read("~/.screenshots/latest.png")
    R-->>SS: Image data (visual)
    SS->>SS: Analyze modal design
    SS-->>U: Analysis + suggestions
```

---

## 4. Optional Route to /ms

When analysis suggests implementation is needed, `/ss` can route to `/ms`:

```mermaid
sequenceDiagram
    participant U as User
    participant SS as /ss
    participant R as Read Tool
    participant MS as /ms

    U->>SS: /ss build this UI
    SS->>R: Read screenshot
    R-->>SS: Image data
    SS->>SS: Analyze: UI mockup
    SS->>U: Analysis complete. Implementation needed?
    U->>SS: Yes, implement it

    rect rgb(240, 250, 230)
        Note over SS,MS: Route to /ms
        SS->>SS: Extract requirements from image
        SS->>MS: /ms "Create React component matching this design: [extracted requirements]"
        MS->>MS: complexity-check → 18
        MS->>MS: Full workflow...
        MS-->>U: Implementation complete
    end
```

**Decision factors for routing:**

- User explicitly asks to "build", "implement", "create"
- Code generation task requires multiple files
- Design mockup needs full component structure

---

## 5. Quick Reference

| Step | Action               | Tool | Model               |
| ---- | -------------------- | ---- | ------------------- |
| 1    | Entry                | -    | -                   |
| 2    | Acknowledge location | -    | -                   |
| 3    | Read image           | Read | Claude (multimodal) |
| 4    | Process instructions | -    | Claude              |
| 5    | Output response      | -    | Claude              |

---

## 6. Example Workflows

### UI Analysis

```
/ss analyze this dashboard
→ Read image
→ Analyze: layout, spacing, colors, typography
→ Output: 5 specific improvement suggestions
```

### Text Extraction

```
/ss extract all text as markdown
→ Read image
→ OCR all visible text
→ Output: Structured markdown document
```

### Debug Visual

```
/ss why is the modal off-center?
→ Read image
→ Identify CSS issue (missing flex centering)
→ Output: Problem + code fix
```

### Design Check

```
/ss does this follow Tailwind conventions?
→ Read image
→ Check spacing (4px increments), colors, etc.
→ Output: Compliance report
```

### Code Generation

```
/ss recreate this as React component
→ Read image
→ Analyze structure, styles
→ Output: React + Tailwind code
```

---

## 7. Integration Points

| Tool/Feature   | Used                         |
| -------------- | ---------------------------- |
| Read tool      | ✅ For image                 |
| /ms routing    | ✅ Optional (if impl needed) |
| Agents         | ❌ None (unless routed)      |
| MCP Tools      | ❌ None (unless routed)      |
| PRD/Vibe Check | ❌ None (unless routed)      |
| Innovate       | ❌ None                      |

**Simplest command in the system** - direct Claude with multimodal input.
When implementation is needed, routes to /ms which handles full workflow.
