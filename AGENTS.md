# Tomas Chyly Common Widgets — Agent Instructions

These instructions apply to the whole repository unless a deeper `AGENTS.md` overrides them.

## Release versioning rule

When releasing a new package version, always update these 3 files together:

1. `pubspec.yaml` - bump `version`.
2. `CHANGELOG.md` - add a new top entry for the released version.
3. `README.md` - update the dependency snippet version (`tch_common_widgets: ^x.y.z`).

All three files must stay in sync for each release.

## General coding conventions

### Imports

- Always use absolute imports (`package:...`) instead of relative imports.

### Code commenting

- Add comments for functions at minimum.
- Add additional comments around special or non-obvious logic.

### TODO ownership format

- When adding TODO comments, use the format: `// TODO(name) some text`.
- Prefer `name` from `git config user.name` of the user running the agent.
- If the name is unknown, ask the user once, then remember and reuse it consistently.

### Enum conventions

- When creating enums, add `none` as the first option unless explicitly instructed otherwise.

### Dart dot shorthands (Flutter 3.38+)

- Prefer Dart dot shorthands in new/edited code when the type is inferable (for example `.start` instead of `MainAxisAlignment.start`, `.all(8)` instead of `EdgeInsets.all(8)`).
- Use dot shorthands for named constructors and enum/static values where it improves conciseness and readability.

## Development workflow

### Context-first preparation

- Before proposing a plan or starting code changes, review related files in the same domain/context to identify established patterns and structure.
- Use those nearby implementations as the primary reference for architecture, naming, state handling, and UI composition decisions.
- If patterns conflict, prefer the closest feature-equivalent example and call out the choice in your summary.

### Tool fallback (`rg`)

- Prefer `rg`/`rg --files` for search when available.
- If `rg` is not available or not working in the current environment, immediately fall back to `grep`/`find` and provide the user with concise `ripgrep` installation instructions for their OS, including at least one web reference.

### Validation

- After finishing code changes, run `flutter analyze` and resolve issues introduced by your changes before handoff.
- Prefer targeting `flutter analyze` to changed files first (for example `flutter analyze lib/path/a.dart lib/path/b.dart`) unless there is a clear reason to run it on the whole project.

### Handoff summary format

- After code changes and validation, include a short summary of changed files in your final response.
- Use plain text (non-clickable) project-relative file references only.
- For each relevant change block, include the starting line number using the `path:line` format (for example `lib/ui/widgets/device/device_form_widget.dart:890`).
- Do not use markdown file links for handoff file references.
- Keep this summary concise and focused on user-impacting or logic-impacting edits.
