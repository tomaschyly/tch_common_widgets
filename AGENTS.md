# Tomas Chyly Common Widgets — Agent Instructions

These instructions apply to the whole repository unless a deeper `AGENTS.md` overrides them.

## Branch safety rule

- For implementation work (any non-planning/non-question-only task), if current branch is `main` or `master`, ask the user first whether to switch to a new `version/*` or `feature/*` branch before making edits.
- Do not start code changes on `main`/`master` until the user confirms how to proceed.

## Release versioning rule

Before deciding independently to update the package version, ask the user whether it should be updated and what the next version should be.

When releasing a new package version, always update these 3 files together:

1. `pubspec.yaml` - bump `version`.
2. `CHANGELOG.md` - add a new top entry for the released version.
   - Focus on important changes, especially breaking changes.
   - Summarize general changes in broad terms rather than listing every single change in each file/class.
3. `README.md` - update the dependency snippet version (`tch_common_widgets: ^x.y.z`).

All three files must stay in sync for each release.

During every package version bump, check the `pubspec.yaml` `environment` constraints against the Flutter version used by the project. When Flutter is upgraded, update the Dart SDK and Flutter constraints together so they remain synchronized with the toolchain.

Current baseline: Flutter `3.44.9` uses:

- `sdk: ">=3.12.0 <4.0.0"`
- `flutter: ">=3.44.0"`

## General coding conventions

### Imports

- Always use absolute imports (`package:...`) instead of relative imports.
- When an extension or method cannot be found, first check whether a required import is missing by finding working examples in similar project files.

### Code commenting

- Add comments for functions at minimum.
- Add additional comments around special or non-obvious logic.
- Follow the comment style established in nearby Flutter/Dart code, including sentence-ending periods where applicable.

### Runtime invariant handling

- Do not hide logically impossible `null` states with silent guard returns.
- If a value must exist at that point in the flow, prefer a loud failure (`!`, thrown error, assertion, or equivalent) so runtime bugs are visible.
- Use guard returns only for valid user or runtime states, not for broken invariants that should be investigated.

### Pattern consistency

- In every change, follow established patterns from related contexts in this project (similar widget, dialog, form, theme, or utility).
- Prefer consistency with existing structure and naming over introducing a new approach.
- If multiple patterns exist, choose the one used in the closest relevant files unless the user explicitly asks otherwise.
- When adding or moving methods, fields, constants, configuration values, or utilities, place them with related code rather than at the end of the file or the first convenient location.
- Before editing a file, scan nearby declarations for the existing grouping and order pattern, then preserve it.
- In a file centered on a primary class, mixin, extension, or other type, declare that primary type before supporting top-level declarations. Place helper data classes, enums, constants, typedefs, and similar supporting declarations after the primary type unless Dart, Flutter, or the file's established structure requires a different order.
- For cross-file lists or registries that represent the same domain concept, keep their order consistent.

### Package architecture and public API

- Keep reusable widget, dialog, form, and theme primitives under `lib/src/`.
- Keep public exports intentionally curated through `lib/tch_common_widgets.dart`; do not expose internal implementation files unless they are part of the supported package API.
- Keep helpers inside a component or feature file only when they are used exclusively by that component or feature; otherwise place them with the closest reusable domain code under `lib/src/`.
- Avoid breaking public constructors, style fields, APIs, and exports without explicit user approval. Document approved breaking changes prominently in `CHANGELOG.md`.

### Button loading state

- When a `ButtonWidget` or `IconButtonWidget` receives a loading value through `isLoading`, do not use the same loading value to disable or guard that button's `onTap` callback.
- Derive `onTap` only from the action's actual eligibility, such as validation or selection state. Both widgets already prevent taps and display the correct loading UI while `isLoading` is true.

### Build method data processing

- Keep widget build methods focused on composing UI from already prepared values.
- Prefer preparing and storing derived collections when source data is received instead of sorting, grouping, mapping, filtering, or calculating potentially expensive values during every build.
- Recompute derived state when its source data changes. Perform transformations in build methods only when they are trivial or depend on the current inherited UI context.

### TODO ownership format

- When adding TODO comments, use the format: `// TODO(name) some text`.
- Prefer `name` from `git config user.name` of the user running the agent.
- If the name is unknown, ask the user once, then remember and reuse it consistently.
- Treat existing TODOs as informational only; do not execute or integrate them unless the user explicitly requests that TODO work.

### Enum conventions

- When creating enums, add `none` as the first option unless explicitly instructed otherwise.

### Dart dot shorthands (Flutter 3.38+)

- Prefer Dart dot shorthands in new/edited code when the type is inferable (for example `.start` instead of `MainAxisAlignment.start`, `.all(8)` instead of `EdgeInsets.all(8)`).
- Use dot shorthands for named constructors and enum/static values where it improves conciseness and readability.

### Date handling

- Prefer `Jiffy` for user-facing date/time formatting and richer date operations when it makes the code simpler.
- Use `DateTime` for basic timestamp parsing, storage, and straightforward conversions where richer date operations are unnecessary.
- Keep consistency with the surrounding file when its existing approach is reasonable; do not refactor unrelated date code.

### `copyWith` nullable clear pattern

- When `copyWith` must support both keeping an existing nullable value and explicitly clearing it to `null`, use a companion clear flag.
- Follow the pattern `field` + `clearField` (for example `locationId` + `clearLocationId`).
- In mapping, prefer: `field: clearField == true ? null : (field ?? this.field)`.
- Do not use sentinel placeholders (for example `_copyWithUndefined`) for this case unless explicitly requested.

## Security

### Dependency updates

- Do not update a pub package, framework, library, or dependency to a version that has been publicly available for fewer than 30 days.
- Before choosing the latest version, verify its release date from an official source such as the package registry, vendor release notes, or repository release page.
- If the latest version is newer than 30 days, select the newest version that is at least 30 days old and explain the choice in the handoff.
- An urgent security fix may use a newer version only when the user explicitly approves that specific update.

## Development workflow

### Cross-project feature planning

- When a feature is likely to affect this package and multiple consuming projects, or take multiple days, suggest creating a plan before writing code.
- Signals that a feature warrants a plan include public API changes, domain models, integrations, or workflows that may have ripple effects across consumers.
- Ask the user which consuming projects are affected before proposing a cross-project plan, and outline the expected scope for each affected project.
- If the user wants to start coding immediately without a plan, respect that choice after noting the suggestion once.

### Context-first preparation

- Before proposing a plan or starting code changes, review related files in the same domain/context to identify established patterns and structure.
- Use those nearby implementations as the primary reference for architecture, naming, state handling, and UI composition decisions.
- If patterns conflict, prefer the closest feature-equivalent example and call out the choice in your summary.

### Tool fallback (`rg`)

- Prefer `rg`/`rg --files` for search when available.
- If `rg` is not available or not working in the current environment, immediately fall back to `grep`/`find` and provide the user with concise `ripgrep` installation instructions for their OS, including at least one web reference.

### Validation

- After finishing code changes, run `dart format` on changed Dart files, then run `flutter analyze` and resolve issues introduced by your changes before handoff.
- Prefer targeting both commands at changed files (for example `dart format lib/path/a.dart lib/path/b.dart` followed by `flutter analyze lib/path/a.dart lib/path/b.dart`) unless there is a clear reason to run them on the whole project.
- Run example-app validation when changes affect plugin/platform registration or the example app.

### Handoff summary format

- After code changes and validation, include a short summary of changed files in your final response.
- Use plain text (non-clickable) project-relative file references only.
- For each relevant change block, include the starting line number using the `path:line` format (for example `lib/ui/widgets/device/device_form_widget.dart:890`).
- Do not use markdown file links for handoff file references.
- Keep this summary concise and focused on user-impacting or logic-impacting edits.

### Long-term plans

- Do not create a new plan file unless the user explicitly asks for one.
- Keep active plans in `plans/` and completed plans in `plans/archive/`.
- When working on a task that corresponds to a plan step, reference the relevant plan file and tick completed checklist items as part of the handoff.
- When all items in a phase are complete, append `[DONE]` to its heading.
- Before moving a completed plan to `plans/archive/`, ask the user to confirm that the plan is complete and no new steps will be added.
- When archiving a plan, add `Finished: YYYY-MM-DD` immediately below its ID/title heading as the second line, using the date the plan is finished and moved to `plans/archive/`.

### Meeting-focused plan markers

- When a plan has points that need meeting discussion, add a `## Meeting focus` section near the top of the plan.
- Use GitLab-friendly text labels instead of relying on colors or custom styling.
- Include this label legend in the meeting focus section:
  - `**[DECISION]**` - needs a product or architecture choice before implementation can be finalized.
  - `**[VERIFY]**` - needs review or validation but likely does not need a product decision.
  - `**[BLOCKER]**` - blocks dependent implementation work.
- Include a short checklist of current focus items, and prefix the matching original checklist items with the same label.
- Keep the meeting focus list curated; remove or tick items when their source checklist item is resolved.
