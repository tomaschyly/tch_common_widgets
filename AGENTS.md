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
