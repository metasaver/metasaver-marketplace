---
name: ss
description: Screenshot command - acknowledges screenshot saved to ~/.screenshots/latest.png and processes instructions about the image
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

The rest of the user's prompt (after `/ss`) contains instructions about what to do with the screenshot. Common tasks:

- **UI Analysis**: Review design, layout, spacing, colors
- **Text Extraction**: OCR and extract visible text
- **Debugging**: Identify visual bugs, alignment issues
- **Comparison**: Check against design systems or specifications
- **Documentation**: Describe what's shown in the image
- **Code Generation**: Create code to replicate the UI shown

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

## Integration

This command works with:
- Read tool for image viewing (PNG, JPG, etc.)
- React component agent for UI recreation
- Design system analysis
- Accessibility validation
- OCR text extraction

## Notes

- The screenshot location is always `~/.screenshots/latest.png`
- Images are presented visually (Claude supports multimodal input)
- You can analyze design, extract text, debug issues, or generate code
- Focus on the specific task in the user's prompt after `/ss`
