---
name: react
description: Apply portable React and TypeScript architecture and style guidance for maintainable, feature-oriented frontends. Use when writing, reviewing, refactoring, or planning React code, especially around component boundaries, hooks, state, data fetching, file size, accessibility, tests, and larger frontend organization.
---

# React Style

Use this skill to shape React code that is easy to understand, test, refactor, and evolve. Favor feature-owned modules, small components, accessible UI, stable hooks, explicit data flow, and boring TypeScript.

## Quick workflow

1. Identify the feature or product area that owns the behavior.
2. Keep route/page components focused on composition, data wiring, and layout.
3. Extract reusable UI, stateful hooks, pure helpers, and data access when they become independently understandable.
4. Keep server state, client state, form state, and derived UI state separate.
5. Make loading, empty, error, disabled, and permission states explicit.
6. Test through user-visible behavior and accessible queries.
7. Review file size, hook stability, accessibility, and type safety before finishing.

## Architecture rules

- Organize by feature or domain first; use shared component folders only for truly reusable UI.
- Prefer colocating feature-specific components, hooks, helpers, queries, fixtures, and tests.
- Keep cross-feature dependencies flowing through clear public exports instead of deep imports into internals.
- Avoid catch-all utility files unless the helpers are small, stable, and domain-free.
- Do not push business rules into visual components when they can live in named helpers or hooks.
- Keep generated code, API documents, and schema types separate from hand-written UI logic.

## Module roles

- **Pages/routes:** compose feature UI, read route state, connect data sources, and set page-level concerns. Avoid becoming all-in-one files with every cell, modal, mutation, and helper inline.
- **Components:** render UI from props. Prefer small, named components with explicit props and minimal knowledge of global state.
- **Hooks:** own reusable stateful behavior, subscriptions, browser APIs, async orchestration, or shared interaction logic. Keep hook return values stable and intentional.
- **Query/data modules:** define server operations, query keys, fetchers, mutations, and cache boundaries. Keep transport details out of presentational components.
- **Helpers:** keep pure transformations, formatting, filtering, sorting, and validation independent from rendering when practical.

## Component and function structure

- Keep imports organized by external packages, app modules, then local modules.
- Define constants, types, small pure helpers, and subcomponents above the exported component when local to the file.
- Put the primary exported component or hook where it is easy to find.
- Prefer discriminated unions for UI modes and pending actions instead of loose boolean clusters.
- Name event handlers by intent, not DOM mechanics, when the intent matters.
- Avoid deeply nested JSX. Extract named components or render helpers when markup obscures the flow.
- Avoid clever generic abstractions until at least two or three real call sites prove the shape.

## Hooks and state

- Use `useEffect` sparingly. Effects should synchronize with external systems, not derive data that can be computed during render.
- Every effect dependency must be a stable reference or intentionally memoized. Do not silence dependency issues by omission.
- Prefer derived values over duplicated state.
- Use refs for mutable values that should not trigger renders; do not use refs to bypass normal data flow.
- Keep server state in data-fetching/cache mechanisms, not copied into local state unless editing or staging changes.
- Keep form state close to the form; lift it only when multiple components need to coordinate.
- Memoize only when it prevents real churn, stabilizes dependencies, or protects expensive work.

## TypeScript rules

- Model domain and UI states precisely. Prefer unions and narrow types over optional bags of unrelated fields.
- Do not use `any`, `as any`, `@ts-ignore`, or `@ts-expect-error` to force code through type checks.
- Prefer type-only imports for types.
- Avoid broad prop types that expose implementation detail.
- Keep component props explicit and minimal; pass values and callbacks instead of large objects when it improves clarity.
- Preserve generated or external types at boundaries, then map into UI-friendly shapes when needed.

## Styling and accessibility

- Use semantic elements and accessible names before adding test IDs or custom ARIA.
- Buttons, links, inputs, dialogs, menus, and status messages should be keyboard-accessible by default.
- Prefer visible labels and user-facing text that tests can query.
- Use relative units for CSS lengths where practical; reserve raw pixels for third-party APIs or exact canvas/positioning needs.
- Keep styling close to the component when it is local; extract shared styles only after reuse is real.
- Treat loading, empty, error, and disabled states as part of the design, not afterthoughts.

## File size guidance

Treat these as review prompts, not hard laws:

- Under 150 lines: ideal for focused components, hooks, helpers, and tests.
- 150-300 lines: acceptable for moderately complex feature pieces.
- 300-600 lines: pause and look for extractable components, hooks, helpers, or query modules.
- Over 600 lines: should be justified by cohesive complexity or split soon.
- Over 1,000 lines: usually a feature page, wizard, large test, or form that needs decomposition.

Split when unrelated UI states, several modals, heavy data orchestration, complex tables, form logic, or many pure helpers accumulate in one file.

## Testing guidance

- Test user-visible behavior, not implementation details.
- Prefer accessible queries by role, label, and text. Use test IDs only when no accessible query expresses the behavior.
- Use realistic user events instead of directly calling handlers.
- Test loading, empty, error, success, and permission states when relevant.
- Mock network and browser boundaries, not the component's internal functions.
- Keep tests colocated with the component, hook, or helper they verify when the project structure supports it.
- Extract test render helpers for providers, but keep them simple and explicit.

## Review checklist

Before finishing, check: feature ownership, thin page/route, cohesive components, stable effects, separated state types, explicit async states, accessible interactions, precise TypeScript, reasonable file size, meaningful tests, and no avoidable deep imports or catch-all utilities.
