# React App Structure Reference

## Naming Conventions

### Directories

- **Domains:** kebab-case (e.g., `service-catalog`, `datafeedr`)
- **Features:** kebab-case with `-feature` suffix (e.g., `microservices-feature`)
- **Pages:** kebab-case matching feature (e.g., `micro-services.tsx`)

### Files

- **Components:** kebab-case for filenames (e.g., `microservices-datagrid.tsx`)
- **Component Exports:** PascalCase (e.g., `export function MicroservicesDatagrid()`)
- **Hooks:** kebab-case with `use-` prefix (e.g., `use-get-microservices.ts`)
- **Types:** PascalCase for interfaces/types (e.g., `interface MicroserviceConfig`)

### Example

```
features/service-catalog/microservices-feature/
├── index.ts                          (export * from "./microservices")
├── microservices.tsx                 (export function MicroservicesFeature)
├── components/
│   ├── index.ts                     (export * from "./...")
│   ├── microservices-datagrid.tsx   (export function MicroservicesDatagrid)
│   └── microservices-toolbar.tsx    (export function MicroservicesToolbar)
├── hooks/
│   ├── index.ts                     (export * from "./use-get-microservices")
│   └── use-get-microservices.ts     (export function useGetMicroservices)
└── config/
    ├── index.ts                     (export * from "./...")
    └── microservice-columns.ts      (export const COLUMNS = [...])
```

## Import Paths

### Path Aliases (tsconfig.json)

```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

### Import Examples

```typescript
// Features
import { MicroservicesFeature } from "@/features/microservices-feature";

// Pages
import { MicroServicesPage } from "@/pages/service-catalog/micro-services";

// Config
import { siteConfig, menuItems } from "@/config";
import { auth0Config } from "@/config/auth-config";

// Library
import { useApiClient, createApiClient } from "@/lib/api-client";

// Routes
import { ROUTES } from "@/routes/route-types";
```

## Domain Structure Examples

### Service Catalog Domain

```
features/service-catalog/
├── microservices-feature/
├── endpoints-feature/
└── schedule-feature/

pages/service-catalog/
├── micro-services.tsx
├── endpoints.tsx
└── schedule.tsx
```

### DataFeedr Domain

```
features/datafeedr/
├── merchants-feature/
├── networks-feature/
├── products-feature/
└── status-feature/

pages/datafeedr/
├── merchants.tsx
├── networks.tsx
├── products.tsx
└── status.tsx
```

## Data Flow Pattern

```
Page Component (thin wrapper)
    ↓
Feature Component (business logic)
    ├── Custom Hooks (useGetMicroservices, useApiClient)
    │   ├── API calls (apiClient.get, apiClient.post)
    │   └── State management (useState, useReducer)
    └── Sub-Components
        ├── DataGrid Component
        └── Toolbar Component
```

### Example Feature Data Flow

```typescript
// src/features/microservices-feature/microservices.tsx
export function MicroservicesFeature() {
  // Use custom hook for data
  const { data, loading, error } = useGetMicroservices();

  // Render sub-components
  return (
    <div>
      <MicroservicesToolbar />
      <MicroservicesDatagrid data={data} loading={loading} />
    </div>
  );
}

// src/features/microservices-feature/hooks/use-get-microservices.ts
export function useGetMicroservices() {
  const apiClient = useApiClient();
  const [data, setData] = useState([]);

  useEffect(() => {
    apiClient.get("/microservices").then(res => setData(res.data));
  }, [apiClient]);

  return { data, loading, error };
}
```

## Environment Variables

### Required Variables

```env
# Auth0
VITE_AUTH0_DOMAIN=your-tenant.auth0.com
VITE_AUTH0_CLIENT_ID=your-client-id
VITE_AUTH0_REDIRECT_URI=http://localhost:5173
VITE_AUTH0_AUDIENCE=your-api-identifier

# API
VITE_API_URL=http://localhost:3000

# App
VITE_APP_URL=http://localhost:5173
```

### Usage in Code

```typescript
// config/auth-config.ts
export const auth0Config = {
  domain: import.meta.env.VITE_AUTH0_DOMAIN,
  clientId: import.meta.env.VITE_AUTH0_CLIENT_ID,
};

// lib/api-client.ts
const baseURL = import.meta.env.VITE_API_URL;
```

## Component Composition Patterns

### Pattern 1: Feature with Hooks

```typescript
// Feature component uses custom hook
export function MicroservicesFeature() {
  const { data } = useGetMicroservices();
  return <MicroservicesDatagrid data={data} />;
}
```

### Pattern 2: Container/Presentational

```typescript
// Container (in feature)
export function MicroservicesFeature() {
  const [filters, setFilters] = useState();
  return <MicroservicesContainer filters={filters} />;
}

// Presentational (in components)
export function MicroservicesContainer({ filters }) {
  return <MicroservicesDatagrid filters={filters} />;
}
```

### Pattern 3: Config-Driven Rendering

```typescript
// Hook returns both data and column config
export function useGetMicroservices() {
  const data = fetchData();
  const columns = MICROSERVICE_COLUMNS;
  return { data, columns };
}

// Component renders with config
export function MicroservicesFeature() {
  const { data, columns } = useGetMicroservices();
  return <DataGrid data={data} columns={columns} />;
}
```

## TypeScript Patterns

### Feature Props Interface

```typescript
export interface MicroservicesFeatureProps {
  defaultFilter?: string;
  onSelect?: (id: string) => void;
}

export function MicroservicesFeature(props: MicroservicesFeatureProps) {
  const { defaultFilter = "", onSelect } = props;
  // ...
}
```

### Shared Types (in @metasaver/contracts)

```typescript
// @metasaver/admin-contracts/src/microservices.ts
export interface Microservice {
  id: string;
  name: string;
  endpoint: string;
  status: "active" | "inactive";
}

export interface MicroserviceCreateRequest {
  name: string;
  endpoint: string;
}
```

### Config Type

```typescript
export const MICROSERVICE_COLUMNS = [
  { field: "name", label: "Name" },
  { field: "endpoint", label: "Endpoint" },
] as const;

export type MicroserviceColumn = (typeof MICROSERVICE_COLUMNS)[number];
```

## Testing Patterns

### Feature Component Test

```typescript
import { render, screen } from "@testing-library/react";
import { MicroservicesFeature } from "@/features/microservices-feature";

describe("MicroservicesFeature", () => {
  it("renders microservices", () => {
    render(<MicroservicesFeature />);
    expect(screen.getByText("Microservices")).toBeInTheDocument();
  });
});
```

### Hook Test

```typescript
import { renderHook, waitFor } from "@testing-library/react";
import { useGetMicroservices } from "@/features/microservices-feature";

describe("useGetMicroservices", () => {
  it("fetches microservices", async () => {
    const { result } = renderHook(() => useGetMicroservices());

    await waitFor(() => {
      expect(result.current.data).toBeDefined();
    });
  });
});
```

## Performance Optimization

### Code Splitting with Lazy Loading

```typescript
// routes.tsx
const MicroServicesPage = lazy(() =>
  import("@/pages/service-catalog/micro-services").then((m) => ({
    default: m.MicroServicesPage,
  }))
);

// Wrap with Suspense
<Suspense fallback={<LoadingFallback />}>
  <MicroServicesPage />
</Suspense>
```

### Memoization Patterns

```typescript
import { memo } from "react";

// Memoize sub-component if it has expensive renders
export const MicroservicesDatagrid = memo(function MicroservicesDatagrid({
  data,
}) {
  return <table>{/* ... */}</table>;
});
```

### useMemo for Expensive Computations

```typescript
const processedData = useMemo(() => {
  return data.map((item) => ({
    ...item,
    computed: expensiveCalculation(item),
  }));
}, [data]);
```

## Migration Checklist

When moving an app to this structure:

- [ ] Create `src/` directory structure
- [ ] Move assets to `src/assets/`
- [ ] Create `src/config/` with `index.tsx` and `auth-config.ts`
- [ ] Create `src/lib/api-client.ts`
- [ ] Create `src/routes/` with `route-types.ts` and `routes.tsx`
- [ ] Create `src/pages/` by domain
- [ ] Create `src/features/` by domain
- [ ] Update all imports to use `@/` path aliases
- [ ] Ensure all components have barrel exports
- [ ] Verify page-to-feature alignment
- [ ] Test lazy loading and code splitting
