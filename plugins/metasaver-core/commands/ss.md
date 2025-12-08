---
name: ss
description: Screenshot command - acknowledges screenshot saved to ~/.screenshots/latest.png and processes instructions about the image
---

# MetaSaver Constitution

| #   | Principle       | Rule                                      |
| --- | --------------- | ----------------------------------------- |
| 1   | **Minimal**     | Change only what must change              |
| 2   | **Root Cause**  | Fix the source, not symptoms              |
| 3   | **Read First**  | Understand existing code before modifying |
| 4   | **Verify**      | Confirm it works before marking done      |
| 5   | **Exact Scope** | Do what was asked—no more, no less        |

---

# Screenshot Command

Quick command for working with screenshots saved to the standard location.

## Usage

```bash
# Analyze a screenshot
/ss analyze this UI and suggest improvements

# Extract text from screenshot
/ss extract all text from this image

# Debug visual issues
/ss what's wrong with the layout in this screenshot?

# Compare with design
/ss does this match our design system?
```

## How It Works

### Step 1: Acknowledge Screenshot Location

The command tells you that a screenshot has been saved to:

```
~/.screenshots/latest.png
```

You should acknowledge this location and confirm you'll read the image file.

### Step 2: Read the Screenshot

Use the Read tool to view the image:

```
Read("~/.screenshots/latest.png")
```

The Read tool supports image files (PNG, JPG, etc.) and will present the visual content for analysis.

### Step 3: Process User Instructions

The rest of the user's prompt (after `/ss`) contains instructions about what to do with the screenshot.

**Instruction Types:**

| Type            | Actions                                    |
| --------------- | ------------------------------------------ |
| UI Analysis     | Review layout, spacing, colors, typography |
| Text Extraction | OCR extraction, structure as markdown      |
| Debug Visual    | Identify CSS issues, alignment bugs, fixes |
| Design Check    | Compare to specs, verify Tailwind patterns |
| Code Generation | Recreate UI as React components, HTML/CSS  |

### Step 4: Provide Response

Based on the screenshot content and user's instructions:

1. Describe what you see (if relevant)
2. Answer the user's question or complete their task
3. Provide specific, actionable feedback
4. Reference specific visual elements when making suggestions

## Examples

### Example 1: UI Analysis

```bash
User: /ss analyze this dashboard and suggest improvements

→ Read ~/.screenshots/latest.png
→ Analyze layout, spacing, typography, color scheme
→ Provide specific suggestions:
  - Increase whitespace between cards
  - Use consistent button styles
  - Improve color contrast for accessibility
  - Align grid items properly
```

### Example 2: Text Extraction

```bash
User: /ss extract all text and create a markdown document

→ Read ~/.screenshots/latest.png
→ Extract all visible text using OCR
→ Structure into markdown format
→ Preserve hierarchy (headings, lists, paragraphs)
```

### Example 3: Debug Visual Issue

```bash
User: /ss why is the modal not centered?

→ Read ~/.screenshots/latest.png
→ Analyze modal positioning
→ Identify CSS issues:
  - Missing `margin: 0 auto`
  - Incorrect flexbox centering
  - Viewport height calculation problem
→ Provide code fix
```

### Example 4: Design System Compliance

```bash
User: /ss does this follow our Tailwind design system?

→ Read ~/.screenshots/latest.png
→ Compare against Tailwind conventions
→ Check:
  - Spacing (4, 8, 16, 24, 32px increments)
  - Colors (from palette)
  - Typography (font sizes, weights)
  - Component patterns
→ Report violations and suggest corrections
```

## Best Practices

1. **Always read the image first** - Don't assume content, actually view the screenshot
2. **Be specific** - Reference exact visual elements, colors, positions
3. **Provide context** - Explain why something is a problem, not just that it is
4. **Offer solutions** - Give actionable fixes with code examples when applicable
5. **Consider accessibility** - Check color contrast, font sizes, touch targets
6. **Think mobile-first** - If responsive design is relevant, mention it

## Optional Routing to /ms

When the screenshot analysis suggests implementation is needed, `/ss` can offer to route to `/ms`:

### When to Offer Routing

- User says "build this", "implement this", "create this component"
- Design mockup needs full React component structure
- Multi-file implementation required
- Code generation task is complex (score would be 5+)

### Routing Pattern

```bash
User: /ss build this UI design

→ Read ~/.screenshots/latest.png
→ Analyze: This is a modal dialog with form fields
→ Ask: "This will require creating multiple files. Route to /ms for full implementation?"
→ If yes: Extract requirements from image
→ Route to: /ms "Create React modal dialog matching design: [extracted requirements]"
→ /ms handles complexity scoring and workflow selection
```

### Requirements Extraction

When routing to /ms, extract from the screenshot:

- Component structure (layout, sections)
- Visual elements (buttons, inputs, icons)
- Text content (labels, placeholders)
- Styling requirements (colors, spacing, typography)

---

## Integration

This command works with:

- Read tool for image viewing (PNG, JPG, etc.)
- /ms command for complex implementations (optional routing)
- React component agent for UI recreation
- Design system analysis
- Accessibility validation
- OCR text extraction

## Quick Reference

| Step | Action               | Tool            | Model               |
| ---- | -------------------- | --------------- | ------------------- |
| 1    | Acknowledge location | -               | -                   |
| 2    | Read image           | Read            | Claude (multimodal) |
| 3    | Process instructions | -               | Claude              |
| 4    | Output response      | -               | Claude              |
| 5    | Route to /ms         | Task (optional) | Per complexity      |

**Integration Points:**

| Tool/Feature   | Used                         |
| -------------- | ---------------------------- |
| Read tool      | ✅ For image                 |
| /ms routing    | ✅ Optional (if impl needed) |
| Agents         | ❌ None (unless routed)      |
| MCP Tools      | ❌ None (unless routed)      |
| PRD/Vibe Check | ❌ None (unless routed)      |
| Innovate       | ❌ None                      |

**Simplest command in the system** - direct Claude with multimodal input. For complex implementations, routes to /ms which handles full workflow.

## Notes

- The screenshot location is always `~/.screenshots/latest.png`
- Images are presented visually (Claude supports multimodal input)
- You can analyze design, extract text, debug issues, or generate code
- Focus on the specific task in the user's prompt after `/ss`
- For complex implementations, route to /ms which handles full workflow
