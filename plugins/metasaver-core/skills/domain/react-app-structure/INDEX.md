# React App Structure Skill - Complete Index

This skill documents the complete file and folder structure for MetaSaver React portal applications. It provides guidelines for scaffolding, auditing, and maintaining consistent architecture across admin-portal, service-catalog, datafeedr, and other portal apps.

## Skill Files Overview

### Core Documentation

**1. SKILL.md** - Primary skill specification

- YAML frontmatter with name, description, allowed tools
- Purpose and use cases
- Complete directory structure reference
- File organization rules for each folder
- Audit checklist (comprehensive)
- Common violations and fixes
- Examples (audit, add feature, validate alignment)
- Related skills

**2. reference.md** - Detailed patterns and conventions

- Naming conventions (directories, files, components)
- Import path patterns and tsconfig setup
- Domain structure examples (service-catalog, datafeedr)
- Data flow patterns
- Environment variables reference
- Component composition patterns
- TypeScript patterns
- Testing patterns
- Performance optimization techniques
- Migration checklist

**3. TEMPLATES.md** - Template file reference guide

- Purpose and location of each template
- Exports and features of each template
- Quick scaffolding sequence
- Template customization tips
- Template statistics

**4. AUDIT_GUIDE.md** - Step-by-step audit instructions

- Quick audit commands (bash)
- Detailed audit checklist (9 levels)
- Import path validation
- Environment variables validation
- Performance checks
- Violations report template
- Automated audit script
- Remediation guide
- Reporting template

**5. INDEX.md** - This file

- Navigation guide for all skill files
- Quick reference section

---

## Templates Directory

### Configuration Templates

- **config-index.tsx.template** - Site config and menu items
  - Location: `src/config/index.tsx`
  - Exports: siteConfig, menuItems
  - Use: App configuration and navigation

- **auth-config.ts.template** - Auth0 configuration
  - Location: `src/config/auth-config.ts`
  - Exports: auth0Config, Auth0Config type
  - Use: Authentication setup

### Library Templates

- **api-client.ts.template** - API client with auth
  - Location: `src/lib/api-client.ts`
  - Exports: createApiClient(), useApiClient(), default
  - Use: API communication layer

### Root Component Templates

- **app.tsx.template** - Root app component
  - Location: `src/app.tsx`
  - Wraps: Auth0Provider, RouterProvider
  - Use: Application bootstrap

- **main.tsx.template** - React entry point
  - Location: `src/main.tsx`
  - Creates: ReactDOM root
  - Use: App initialization

- **index.css.template** - Global styles
  - Location: `src/index.css`
  - Contains: Tailwind directives, theme imports
  - Use: Styling setup

### Routes Templates

- **route-types.ts.template** - Type-safe routes
  - Location: `src/routes/route-types.ts`
  - Exports: ROUTES constant, Route type
  - Use: Route configuration

- **routes.tsx.template** - React Router config
  - Location: `src/routes/routes.tsx`
  - Features: Lazy loading, Suspense, error handling
  - Use: Route setup with code splitting

### Page Templates

- **page-wrapper.tsx.template** - Thin page wrapper
  - Location: `src/pages/{domain}/{page}.tsx`
  - Pattern: Import feature, render feature
  - Use: Page file creation

### Feature Templates

- **feature-barrel-export.ts.template** - Barrel export
  - Location: `src/features/{domain}/{feature}/index.ts`
  - Pattern: Export from subfolders
  - Use: Feature folder setup

- **feature-component.tsx.template** - Feature component
  - Location: `src/features/{domain}/{feature}/{feature}.tsx`
  - Includes: Props, hooks, API calls, state
  - Use: Feature implementation

---

## Quick Reference

### Directory Structure Summary

```
src/
├── assets/                      (Logo SVG)
├── config/                      (siteConfig, menuItems, auth0Config)
├── lib/                         (api-client)
├── features/                    (By domain, with -feature suffix)
│   └── {domain}/
│       └── {feature}/
│           ├── {feature}.tsx
│           ├── index.ts
│           ├── components/
│           ├── hooks/
│           └── config/
├── pages/                       (By domain, mirrors features)
│   └── {domain}/
│       └── {page}.tsx
├── routes/                      (route-types.ts, routes.tsx)
├── styles/                      (theme-overrides.css)
├── app.tsx                      (Root component)
├── main.tsx                     (Entry point)
├── index.css                    (Global styles)
└── vite-env.d.ts                (Type definitions)
```

### Key Rules Summary

1. **Domain Grouping**: features/ and pages/ organized by domain
2. **Barrel Exports**: Every feature and subfolder needs index.ts
3. **Thin Pages**: Pages are wrappers (5-15 lines), no business logic
4. **Type Safety**: Routes use ROUTES constant from route-types.ts
5. **Lazy Loading**: All pages lazy-loaded with Suspense
6. **No Secrets**: Environment variables for all config
7. **Path Aliases**: Use @/ for all imports

### Common Operations

**Audit an app:**

```bash
# Use AUDIT_GUIDE.md commands and checklist
./audit-app-structure.sh /path/to/app
```

**Create new feature:**

```bash
# Follow Example 2 in SKILL.md
# Use feature templates from templates/ directory
```

**Add new route:**

```bash
# 1. Update ROUTES in route-types.ts
# 2. Add lazy route in routes.tsx
# 3. Add menu item in config/index.tsx
```

**Validate page alignment:**

```bash
# Check feature imports match folder structure
# See Example 3 in SKILL.md
```

---

## File Navigation Guide

### By Task

**"I need to scaffold a new React portal app"**

1. Start: SKILL.md - "Directory Structure Reference"
2. Follow: SKILL.md - "Workflow: Scaffolding New Feature"
3. Copy templates from: templates/ directory
4. Customize using: reference.md - "Naming Conventions"

**"I need to audit an existing app"**

1. Start: AUDIT_GUIDE.md - "Quick Audit Commands"
2. Detailed checks: AUDIT_GUIDE.md - "Detailed Audit Checklist"
3. Fix issues: AUDIT_GUIDE.md - "Remediation Guide"

**"I need to add a new feature to an app"**

1. Start: SKILL.md - "Workflow: Scaffolding New Feature"
2. Reference: TEMPLATES.md - "Quick Scaffolding Sequence"
3. Templates: templates/ directory
4. Patterns: reference.md - "Component Composition Patterns"

**"I need to understand the structure patterns"**

1. Overview: SKILL.md - "File Organization Rules"
2. Deep dive: reference.md - all sections
3. Examples: SKILL.md - "Examples" section

**"I need naming convention guidelines"**

1. Quick ref: reference.md - "Naming Conventions"
2. Examples: reference.md - "Example" section in naming

**"I need to understand data flow"**

1. Pattern: reference.md - "Data Flow Pattern"
2. Example: reference.md - "Example Feature Data Flow"
3. Composition: reference.md - "Component Composition Patterns"

**"I need testing guidance"**

1. Patterns: reference.md - "Testing Patterns"
2. Unit tests for features and hooks

**"I need performance optimization tips"**

1. Lazy loading: reference.md - "Code Splitting with Lazy Loading"
2. Memoization: reference.md - "Memoization Patterns"
3. Audit checks: AUDIT_GUIDE.md - "Performance Checks"

---

## Validation Checklist

Before using this skill, ensure:

- [ ] You have a React/TypeScript project
- [ ] Using Vite as build tool
- [ ] Auth0 authentication setup
- [ ] Tailwind CSS configured
- [ ] Path aliases configured in tsconfig.json
- [ ] React Router v6+ installed

---

## Skills Dependencies

This skill references and integrates with:

- **vite-agent** - Vite configuration (vite.config.ts)
- **typescript-configuration-agent** - TypeScript config
- **tailwind-agent** - Tailwind setup
- **postcss-agent** - PostCSS configuration
- **eslint-agent** - ESLint configuration
- **root-package-json-agent** - Dependencies
- **auth0-integration** - Auth0 patterns
- **react-routing** - React Router patterns

---

## Document Statistics

- **Total files**: 15 (4 docs + 11 templates)
- **Total documentation pages**: 4
- **Total template files**: 11
- **Total template code examples**: 30+
- **Audit checklist items**: 50+
- **Pattern examples**: 15+
- **Command examples**: 25+

---

## Version History

- **v1.0** - Initial skill creation
  - Complete directory structure documentation
  - 11 reusable templates
  - Comprehensive audit guide
  - 4 documentation files
  - Pattern library and examples

---

## How to Use This Skill

1. **Discovery**: Start with SKILL.md description
2. **Planning**: Read the relevant section of SKILL.md
3. **Implementation**: Use templates from templates/ directory
4. **Validation**: Follow AUDIT_GUIDE.md checklist
5. **Reference**: Use reference.md for patterns and conventions

---

## Quick Links Summary

| Task                    | File           | Section                           |
| ----------------------- | -------------- | --------------------------------- |
| Overview                | SKILL.md       | Top of file                       |
| Directory structure     | SKILL.md       | Directory Structure Reference     |
| File organization rules | SKILL.md       | File Organization Rules           |
| Scaffolding workflow    | SKILL.md       | Workflow: Scaffolding New Feature |
| Audit checklist         | SKILL.md       | Audit Checklist                   |
| Common violations       | SKILL.md       | Common Violations & Fixes         |
| Naming conventions      | reference.md   | Naming Conventions                |
| Import patterns         | reference.md   | Import Paths                      |
| Data flow               | reference.md   | Data Flow Pattern                 |
| Templates               | TEMPLATES.md   | All sections                      |
| Template usage          | TEMPLATES.md   | Template Usage Guide              |
| Audit commands          | AUDIT_GUIDE.md | Quick Audit Commands              |
| Detailed audit          | AUDIT_GUIDE.md | Detailed Audit Checklist          |
| Fixes                   | AUDIT_GUIDE.md | Remediation Guide                 |

---

## Support

For questions or issues related to:

- **File structure**: See SKILL.md - "Directory Structure Reference"
- **Naming**: See reference.md - "Naming Conventions"
- **Templates**: See TEMPLATES.md - "Template Files Reference"
- **Auditing**: See AUDIT_GUIDE.md - "Detailed Audit Checklist"
- **Patterns**: See reference.md - "Component Composition Patterns"

---

Last updated: 2025-12-05
Skill version: 1.0
