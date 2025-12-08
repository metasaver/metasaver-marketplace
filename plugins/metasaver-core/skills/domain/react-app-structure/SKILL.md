---
name: react-app-structure
description: Use when auditing, scaffolding, or validating MetaSaver React portal app directory structure. Includes file organization patterns, domain grouping, feature composition, routing configuration, and Auth0 integration setup. File types: .tsx, .ts, directory layouts.
allowed-tools: Read, Write, Edit, Bash, Glob
---

# React App Structure for MetaSaver Portal Apps

## Purpose

This skill documents the complete file and folder organization for MetaSaver React portal applications (admin-portal, service-catalog, datafeedr). It ensures consistent patterns across:

- Directory hierarchy by domain/feature
- Config file placement and exports
- Library composition (auth, API clients)
- Page-to-feature mapping
- Type-safe routing
- Component composition patterns

**Use when:**

- Scaffolding a new MetaSaver portal app
- Auditing an existing app structure for compliance
- Adding new features/domains to an app
- Validating page-feature alignment
- Setting up Auth0 or API client integration

## Directory Structure Reference

### Root Configuration Files

These are handled by specialized config agents - reference them:

```
├── vite.config.ts              # (vite-agent) Vite build config
├── tsconfig.json               # (typescript-configuration-agent) Base TS config
├── tsconfig.app.json           # (typescript-configuration-agent) App-specific
├── tsconfig.node.json          # (typescript-configuration-agent) Node config
├── tailwind.config.ts          # (tailwind-agent) Tailwind setup
├── postcss.config.js           # (postcss-agent) PostCSS config
├── eslint.config.js            # (eslint-agent) ESLint config
├── package.json                # (root-package-json-agent) Dependencies
├── index.html                  # Entry HTML file
└── .env.example                # Environment variable template
```

### Public Folder

```
public/
└── favicon.svg                 # Browser tab icon ONLY
                                # Do NOT duplicate icons here
```

**Rule:** `public/` contains favicon.svg for browser tab. Logo goes in `src/assets/logo.svg`.

### Source Structure (Complete)

```
src/
├── assets/
│   └── logo.svg                # Full logo for in-app use (NOT favicon)
│
├── config/
│   ├── index.tsx               # siteConfig, menuItems exports
│   └── auth-config.ts          # Auth0 configuration object
│
├── lib/
│   └── api-client.ts           # Axios client with auth token injection
│
├── features/
│   └── {domain}/               # Grouped by domain (mirrors pages/)
│       └── {feature}/
│           ├── index.ts        # Barrel export: export * from "./{feature}"
│           ├── {feature}.tsx   # Main feature component
│           ├── components/     # (optional) Reusable sub-components
│           │   └── index.ts    # Barrel export
│           ├── hooks/          # (optional) Custom React hooks
│           │   └── index.ts    # Barrel export
│           └── config/         # (optional) Feature-specific config
│               └── index.ts    # Barrel export
│
├── pages/
│   └── {domain}/               # Grouped by domain (mirrors features/)
│       └── {page}.tsx          # Thin wrapper importing from features/
│
├── routes/
│   ├── route-types.ts          # Type-safe ROUTES constant
│   └── routes.tsx              # React Router config with lazy loading
│
├── styles/
│   └── theme-overrides.css     # CSS overrides (global)
│
├── app.tsx                     # Root component with Auth0Provider
├── main.tsx                    # React entry point (ReactDOM.createRoot)
├── index.css                   # Tailwind imports (@tailwind directives)
└── vite-env.d.ts               # Vite type definitions
```

## File Organization Rules

### Features Directory Pattern

**Rule 1: Domain Grouping**
Features are organized by domain to match page structure:

```
features/
├── microservices-feature/      # Maps to pages/service-catalog/micro-services.tsx
├── endpoints-feature/          # Maps to pages/service-catalog/endpoints.tsx
├── merchants-feature/          # Maps to pages/datafeedr/merchants.tsx
└── status-feature/             # Maps to pages/datafeedr/status.tsx
```

**Rule 2: Barrel Exports**
Each feature level must have `index.ts` with barrel exports:

```typescript
// src/features/microservices-feature/index.ts
export * from "./microservices";
export * from "./hooks";
export * from "./components";
export * from "./config";
```

**Rule 3: Component Naming**

- Main component filename matches feature: `microservices.tsx`
- Main component export: `export function MicroservicesFeature() { ... }`
- Sub-components in `components/` subfolder

**Rule 4: Optional Subfolders**
Only create `components/`, `hooks/`, `config/` if they exist:

- No empty folders
- If folder exists, must have `index.ts` barrel export
- Deep nesting (3+ levels) suggests refactoring needed

### Pages Directory Pattern

**Rule 1: Mirrors Features**
Page structure mirrors feature structure by domain:

```
pages/
├── service-catalog/
│   ├── micro-services.tsx
│   ├── endpoints.tsx
│   └── schedule.tsx
├── datafeedr/
│   ├── merchants.tsx
│   ├── networks.tsx
│   ├── products.tsx
│   └── status.tsx
└── home/
    └── home.tsx
```

**Rule 2: Thin Wrappers**
Page files are thin wrappers (5-15 lines):

```typescript
// src/pages/service-catalog/micro-services.tsx
import { MicroservicesFeature } from "@/features/microservices-feature";

export function MicroServicesPage() {
  return <MicroservicesFeature />;
}
```

**Rule 3: No Logic in Pages**

- Pages import from features
- Pages do NOT contain business logic
- Pages do NOT have their own hooks/components
- Exception: Page-level wrappers (auth guards, layouts)

### Config Directory Pattern

**index.tsx** exports:

```typescript
export const siteConfig = {
  name: "Admin Portal",
  description: "...",
  // ...
};

export const menuItems = [
  // Navigation structure
];
```

**auth-config.ts** exports:

```typescript
export const auth0Config = {
  domain: process.env.VITE_AUTH0_DOMAIN,
  clientId: process.env.VITE_AUTH0_CLIENT_ID,
  // ...
};
```

### Routes Pattern

**route-types.ts** defines type-safe routes:

```typescript
export const ROUTES = {
  HOME: "/",
  DASHBOARD: "/dashboard",
  MICROSERVICES: "/service-catalog/microservices",
  // ...
} as const;
```

**routes.tsx** uses lazy loading:

```typescript
import { lazy } from "react";
import { createBrowserRouter } from "react-router-dom";

const HomePage = lazy(() =>
  import("@/pages/home/home").then((m) => ({
    default: m.HomePage,
  }))
);

export const router = createBrowserRouter([
  {
    path: ROUTES.HOME,
    element: <HomePage />,
  },
  // ...
]);
```

### Styles Organization

**theme-overrides.css** contains:

- CSS custom properties overrides
- Global component styles
- Utility classes not in Tailwind

Does NOT contain:

- Component-scoped styles (use Tailwind classes in JSX)
- Animations (inline or separate component files)

## Workflow: Scaffolding New Feature

1. **Create Feature Directory**

   ```bash
   mkdir -p src/features/{domain}/{feature}
   mkdir -p src/features/{domain}/{feature}/components
   mkdir -p src/features/{domain}/{feature}/hooks
   mkdir -p src/features/{domain}/{feature}/config
   ```

2. **Create Feature Files** (use templates)
   - `src/features/{domain}/{feature}/{feature}.tsx`
   - `src/features/{domain}/{feature}/index.ts`
   - `src/features/{domain}/{feature}/components/index.ts`
   - `src/features/{domain}/{feature}/hooks/index.ts`
   - `src/features/{domain}/{feature}/config/index.ts`

3. **Create Page File** (use template)
   - `src/pages/{domain}/{page}.tsx`

4. **Update Routes**
   - Add ROUTES constant in `src/routes/route-types.ts`
   - Add route config in `src/routes/routes.tsx`
   - Add to `menuItems` in `src/config/index.tsx`

## Audit Checklist

### Directory Structure

- [ ] `src/` folder exists
- [ ] All required subdirectories present: `assets`, `config`, `lib`, `features`, `pages`, `routes`, `styles`
- [ ] No `.tsx`/`.ts` files in `src/` root (except `app.tsx`, `main.tsx`, `index.css`, `vite-env.d.ts`)
- [ ] `public/` contains only `favicon.svg` (no other icons)

### Features Directory

- [ ] Features grouped by domain: `features/{domain}/{feature}/`
- [ ] Each feature has `index.ts` with barrel exports
- [ ] Main component: `{feature}.tsx` in feature root
- [ ] Sub-components in `components/` (if exists)
- [ ] Each subfolder has `index.ts`
- [ ] No empty folders
- [ ] Feature names use kebab-case: `microservices-feature`

### Pages Directory

- [ ] Pages mirror feature structure: `pages/{domain}/{page}.tsx`
- [ ] Page files are thin wrappers (< 20 lines)
- [ ] Pages import from `@/features/`
- [ ] No business logic in pages
- [ ] No sub-components in pages folder
- [ ] Page export: `export function {Page}Page()`

### Config Files

- [ ] `src/config/index.tsx` exports `siteConfig` and `menuItems`
- [ ] `src/config/auth-config.ts` exports `auth0Config` object
- [ ] All config uses environment variables
- [ ] No hardcoded API URLs or secrets

### Library Files

- [ ] `src/lib/api-client.ts` exports configured Axios instance
- [ ] API client injects auth token automatically
- [ ] Client handles errors consistently

### Routes

- [ ] `src/routes/route-types.ts` defines `ROUTES` constant
- [ ] All routes in `ROUTES` are type-safe
- [ ] `src/routes/routes.tsx` uses lazy loading for pages
- [ ] Routes match navigation items in config
- [ ] No hardcoded URL strings in components

### Styles

- [ ] `src/styles/theme-overrides.css` contains only overrides
- [ ] Global styles imported in `src/index.css`
- [ ] Tailwind `@tailwind` directives present in `src/index.css`
- [ ] PostCSS configured in `postcss.config.js`

### Root Source Files

- [ ] `src/app.tsx` wraps with Auth0Provider
- [ ] `src/main.tsx` uses `ReactDOM.createRoot()`
- [ ] `src/index.css` imports Tailwind
- [ ] `src/vite-env.d.ts` declares Vite types
- [ ] `index.html` references `src/main.tsx`

### Asset Organization

- [ ] `src/assets/logo.svg` contains full logo
- [ ] `public/favicon.svg` contains browser tab icon ONLY
- [ ] No duplicate icon files
- [ ] Logo imported in config/layout files

## Common Violations & Fixes

**Violation:** Pages contain business logic

```typescript
// WRONG
export function MicroServicesPage() {
  const [services, setServices] = useState([]);
  useEffect(() => { /* fetch logic */ }, []);
  return <ServiceTable services={services} />;
}
```

**Fix:** Move logic to feature component

```typescript
// RIGHT - Page wrapper
export function MicroServicesPage() {
  return <MicroservicesFeature />;
}

// Feature component has logic
export function MicroservicesFeature() {
  const [services, setServices] = useState([]);
  useEffect(() => { /* fetch logic */ }, []);
  return <ServiceTable services={services} />;
}
```

**Violation:** Feature doesn't have barrel export

```typescript
// WRONG - No index.ts
src/features/microservices-feature/
├── microservices.tsx
└── hooks/
    └── use-get-services.ts
```

**Fix:** Add barrel exports

```typescript
// RIGHT
src/features/microservices-feature/
├── index.ts                    // export * from "./microservices"
├── microservices.tsx
├── hooks/
│   ├── index.ts               // export * from "./use-get-services"
│   └── use-get-services.ts
```

**Violation:** Page structure doesn't mirror feature structure

```
features/microservices-feature/        pages/dashboard/
pages/admin/microservices.tsx   ✗      (mismatch in domain/path)
```

**Fix:** Align domain structure

```
features/service-catalog/microservices-feature/
pages/service-catalog/micro-services.tsx   ✓
```

**Violation:** Config file hardcoding values

```typescript
// WRONG
export const auth0Config = {
  domain: "dev-abc123.auth0.com",
  clientId: "xyz789",
};
```

**Fix:** Use environment variables

```typescript
// RIGHT
export const auth0Config = {
  domain: import.meta.env.VITE_AUTH0_DOMAIN,
  clientId: import.meta.env.VITE_AUTH0_CLIENT_ID,
};
```

## Examples

### Example 1: Audit Admin Portal Structure

```bash
# Commands to validate structure
find src -type f -name "*.tsx" -o -name "*.ts" | head -20
ls -la src/features/
ls -la src/pages/
```

Audit checklist:

1. All features have `index.ts`
2. All pages are thin wrappers
3. Routes match config menu items
4. No business logic in pages

### Example 2: Add New Feature (DataFeedr Products)

**Files to create:**

1. `src/features/datafeedr/products-feature/index.ts`
2. `src/features/datafeedr/products-feature/products.tsx`
3. `src/features/datafeedr/products-feature/hooks/index.ts`
4. `src/features/datafeedr/products-feature/hooks/use-get-products.ts`
5. `src/pages/datafeedr/products.tsx`
6. Update `src/routes/route-types.ts`
7. Update `src/routes/routes.tsx`
8. Update `src/config/index.tsx` menuItems

**Use templates for each file.**

### Example 3: Validate Page-Feature Alignment

```typescript
// Check that pages import from matching features
// src/pages/service-catalog/micro-services.tsx
import { MicroservicesFeature } from "@/features/service-catalog/microservices-feature";

// Domain must match: service-catalog / service-catalog ✓
// Feature path must match: microservices-feature / microservices-feature ✓
```

## Related Skills

- **vite-agent** - Vite configuration (vite.config.ts)
- **typescript-configuration-agent** - TypeScript config (tsconfig.json, tsconfig.app.json)
- **tailwind-agent** - Tailwind setup (tailwind.config.ts)
- **postcss-agent** - PostCSS config (postcss.config.js)
- **eslint-agent** - ESLint config (eslint.config.js)
- **root-package-json-agent** - Dependencies (package.json)
- **auth0-integration** - Auth0 setup patterns
- **react-routing** - React Router patterns
