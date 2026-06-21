---
name: elixir
description: Apply portable Elixir architecture and style guidance for maintainable, domain-oriented applications. Use when writing, reviewing, refactoring, or planning Elixir code, especially around module structure, contexts, actions, schemas, workers, queries, file size, and larger codebase organization.
---

# Elixir Style

Use this skill to shape Elixir code that is easy to understand, test, refactor, and operate as it grows. Favor small, domain-owned modules, explicit boundaries, boring control flow, and predictable return values.

## Quick workflow

1. Identify the domain that owns the behavior.
2. Put the public API on the domain context, but keep that context thin.
3. Put use-case logic in an action module or similarly focused internal module.
4. Keep transport, worker, and consumer entrypoints thin; they adapt input and delegate.
5. Keep schemas focused on data shape, associations, types, changesets, and local constraints.
6. Return expected failures as data and test them directly.
7. Review file size, query bounds, retry safety, and domain boundaries before finishing.

## Architecture rules

- Organize by business domain, not by technical layer alone.
- Depend on other domains through their public APIs instead of reaching into internals.
- Avoid catch-all namespaces like `Services`, `Managers`, `Helpers`, or `Utils` unless code is truly shared and stable.
- Put business logic below web, transport, job, and serialization layers.
- Use explicit orchestration modules when one user-visible workflow coordinates multiple concepts.
- Keep shared utilities small, stable, and free of domain assumptions.

## Module roles

- **Contexts:** public face of a domain. Expose stable operations and delegate. Avoid substantial branching, transactions, query construction, or validation logic directly in contexts.
- **Actions:** meaningful use cases. Use clear verb-based purpose, local orchestration, few public functions, and private helpers. Split out query builders, calculators, serializers, or sub-actions when broad.
- **Schemas:** persistence shape: fields, associations, type definitions, changesets, constraints, and local query helpers. Do not put multi-step workflows in schemas.
- **Entrypoints:** controllers, resolvers, channels, jobs, workers, and consumers translate external input into domain calls and translate results back out. They should not contain deep business decisions.

## File and function structure

- Match module names to file paths.
- Use this module order: `use`/`import`/`alias`/`require`, attributes, types, callbacks, public functions, private functions.
- Put main public entrypoints before specialized clauses and helpers.
- Prefer `@moduledoc false` for obvious internal modules; write docs for invariants, side effects, or domain meaning.
- Alias intentionally. Long copied alias lists often signal too many responsibilities.
- Keep functions focused on one abstraction level.
- Separate validation, querying, transformation, side effects, and response shaping when names clarify the flow.
- Use pattern matching for meaningful variants and `case`/`with` for expected branches.
- Avoid exceptions for normal control flow.

## Return values

Prefer predictable, idiomatic return shapes:

- `{:ok, value}` or `:ok` for success.
- `{:error, reason}` for expected failure.
- `true`/`false` from predicate functions ending in `?`.
- Query-building functions usually return a queryable value instead of executing implicitly.

Do not make one function return several unrelated shapes. Add a structured result or separate functions when callers need different detail levels.

## File size guidance

Treat these as review prompts, not hard laws:

- Under 100 lines: ideal for most actions, schemas, workers, and helpers.
- 100-250 lines: acceptable for moderately complex workflows.
- 250-400 lines: pause and look for separable concerns.
- Over 400 lines: rare; justify with cohesive complexity.
- Over 600 lines: usually split a DSL, parser, serializer, query builder, or workflow.

Split when unrelated reasons to change appear, private helpers outnumber core workflow, query construction dominates business logic, entrypoints start making business decisions, or tests become hard to understand.

## Query and persistence rules

- Keep queries explicitly scoped and bounded.
- Filter on indexed columns before large joins when possible.
- Avoid unbounded reads and offset pagination for large tables; prefer keyset pagination or cursors.
- Move complex query composition into named helpers or query modules.
- Use transactions when multiple writes must succeed or fail together; keep transaction steps named by business meaning.
- Keep external network calls outside database transactions unless deliberately justified.
- Use database constraints and indexes for important invariants.
- When conflict-handling writes return data used later, ensure the returned data reflects the database row.

## Async, logging, and tests

- Workers and consumers should be thin, bounded entrypoints into normal domain logic.
- Make retryable operations idempotent with unique constraints, idempotency keys, state checks, or safe upserts.
- Log where enough context exists to be useful; avoid duplicate logs at every layer.
- Include stable identifiers and operation context, but avoid secrets and noisy hot-path logs.
- Treat expected failures as data: validation errors, not-found cases, permission denials, dependency failures, and known business-rule failures.
- Test most business behavior through action modules or public context functions.
- Prefer realistic data over excessive mocks. Mock unstable external boundaries, not the database or the module under test.
- Cover expected non-happy paths directly and capture intentional error-path logs.

## Review checklist

Before finishing, check: domain ownership, thin context, thin entrypoints, bounded/indexed queries, explicit expected failures, retry safety, schema focus, cohesive file size, consistent domain language, useful tests, and non-noisy logs.
