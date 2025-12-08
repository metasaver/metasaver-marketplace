# Template Files Reference

This skill includes the following template files for scaffolding MetaSaver React portal apps. All templates are in the `templates/` directory.

## Configuration Templates

### config-index.tsx.template

**Purpose:** Site configuration and navigation menu
**Location:** `src/config/index.tsx`
**Exports:**

- `siteConfig` - Application metadata
- `menuItems` - Navigation structure

**Use when:** Creating new portal app or updating site config

### auth-config.ts.template

**Purpose:** Auth0 configuration object
**Location:** `src/config/auth-config.ts`
**Exports:**

- `auth0Config` - Auth0 domain, clientId, redirectUri, audience
- `Auth0Config` - Type definition

**Use when:** Setting up Auth0 authentication

### config/index.tsx

Combines site configuration and menu items for app-wide settings.

---

## Library Templates

### api-client.ts.template

**Purpose:** Axios client with Auth0 token injection
**Location:** `src/lib/api-client.ts`
**Exports:**

- `createApiClient(token?)` - Factory for creating configured axios instance
- `useApiClient()` - React hook for component usage
- `default` - Static client instance

**Features:**

- Automatic Authorization header injection
- Error handling for 401 Unauthorized
- Environment-based baseURL configuration

**Use when:** Setting up API communication layer

---

## Root Component Templates

### app.tsx.template

**Purpose:** Root application component with Auth0Provider
**Location:** `src/app.tsx`
**Wraps:**

- Auth0Provider
- RouterProvider

**Use when:** Scaffolding new app

### main.tsx.template

**Purpose:** React entry point using ReactDOM.createRoot
**Location:** `src/main.tsx`

**Use when:** Scaffolding new app

### index.css.template

**Purpose:** Global stylesheet with Tailwind imports
**Location:** `src/index.css`
**Contains:**

- Tailwind directives (@tailwind)
- Theme overrides import
- Global styles

**Use when:** Setting up styling layer

---

## Routes Templates

### route-types.ts.template

**Purpose:** Type-safe route constants
**Location:** `src/routes/route-types.ts`
**Exports:**

- `ROUTES` - Object with all route paths as constants
- `Route` - Type for any valid route

**Pattern:**

```typescript
const ROUTES = {
  HOME: "/",
  DASHBOARD: "/dashboard",
  // ... more routes
} as const;
```

**Use when:** Setting up routing, adding new routes

### routes.tsx.template

**Purpose:** React Router configuration with lazy loading
**Location:** `src/routes/routes.tsx`
**Features:**

- Lazy-loaded page components
- Suspense with loading fallback
- Catch-all redirect
- Type-safe route definitions

**Use when:** Configuring routes and lazy loading

---

## Page Templates

### page-wrapper.tsx.template

**Purpose:** Thin page component wrapper
**Location:** `src/pages/{domain}/{page}.tsx`
**Pattern:**

- Import feature from `@/features/`
- Render feature component
- No business logic
- 5-15 lines total

**Example Output:**

```typescript
import { MicroservicesFeature } from "@/features/microservices-feature";

export function MicroServicesPage() {
  return <MicroservicesFeature />;
}
```

**Use when:** Creating new page file

---

## Feature Templates

### feature-barrel-export.ts.template

**Purpose:** Barrel export for feature folder
**Location:** `src/features/{domain}/{feature}/index.ts`
**Pattern:**

```typescript
export * from "./{feature}";
export * from "./hooks";
export * from "./components";
export * from "./config";
```

**Use when:** Creating new feature, adding subfolders

### feature-component.tsx.template

**Purpose:** Main feature component with business logic
**Location:** `src/features/{domain}/{feature}/{feature}.tsx`
**Includes:**

- Props interface
- useState for state management
- useEffect for data fetching
- useApiClient for API calls
- Sub-component composition
- Error and loading states

**Use when:** Creating new feature component

---

## Template Usage Guide

### Step 1: Copy Template

```bash
# Example: Creating config/index.tsx
cp templates/config-index.tsx.template src/config/index.tsx
```

### Step 2: Customize

Edit the copied file to match your specific:

- Domain names
- Feature names
- Route paths
- Component names
- API endpoints

### Step 3: Validate

Check against the Audit Checklist in SKILL.md:

- File naming conventions
- Barrel exports
- Import paths
- Environment variables

---

## Quick Scaffolding Sequence

For a new feature (e.g., Products):

1. **Create directories:**

   ```bash
   mkdir -p src/features/datafeedr/products-feature/{hooks,components,config}
   ```

2. **Create files from templates:**

   ```bash
   cp templates/feature-barrel-export.ts.template \
      src/features/datafeedr/products-feature/index.ts

   cp templates/feature-component.tsx.template \
      src/features/datafeedr/products-feature/products.tsx

   cp templates/page-wrapper.tsx.template \
      src/pages/datafeedr/products.tsx
   ```

3. **Update config:**
   - Add PRODUCTS route to `src/routes/route-types.ts`
   - Add route to `src/routes/routes.tsx`
   - Add menu item to `src/config/index.tsx`

4. **Update imports:**
   - Rename imports in page wrapper
   - Rename feature component name
   - Create hook and component subfolders

---

## Template Customization Tips

### Naming

- Replace `{feature}` with actual feature name (kebab-case)
- Replace `{Feature}` with PascalCase equivalent
- Replace `{domain}` with domain name (e.g., service-catalog)

### File References

- Update `.tsx`/`.ts` paths in exports
- Use `@/` path aliases
- Match folder structure to domain

### Environment Variables

- Keep `import.meta.env.VITE_*` pattern
- Document required variables in .env.example
- Never hardcode values

---

## Related Documentation

- **SKILL.md** - Complete skill documentation and audit checklist
- **reference.md** - Detailed patterns, conventions, and examples
- **TEMPLATES.md** - This file

---

## Template Statistics

- **Total templates:** 11
- **Configuration files:** 2 (.ts/.tsx files)
- **Library files:** 1 (api-client)
- **Root components:** 3 (app, main, styles)
- **Routes:** 2 (types, router config)
- **Pages:** 1 (wrapper pattern)
- **Features:** 2 (barrel export, component)

All templates are ready to use with minimal customization for MetaSaver portal apps.
