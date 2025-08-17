# Repository Guidelines

## Project Structure & Module Organization
- App entry: `Noty/App/NotyApp.swift` with root view in `Noty/App/ContentView.swift`.
- UI: reusable components in `Noty/Views/Components`, screens in `Noty/Views/Screens`.
- Domain: models and managers in `Noty/Models` (e.g., `NotesManager`, `SearchManager`).
- Utilities: helpers and extensions in `Noty/Utils`.
- Assets: images and colors in `Noty/Ressources` and `Noty/Ressources/Assets.xcassets`.
- Xcode project: `Noty.xcodeproj`. No test target is present yet.

## Build, Test, and Development Commands
- Open in Xcode: `open Noty.xcodeproj` (select the `Noty` scheme, choose a Simulator, Run).
- Build (CLI): `xcodebuild -project Noty.xcodeproj -scheme Noty -configuration Debug build`.
- Clean: `xcodebuild -project Noty.xcodeproj -scheme Noty clean`.
- Test (when tests exist): `xcodebuild -project Noty.xcodeproj -scheme Noty -destination 'platform=iOS Simulator,name=iPhone 15' test`.

## Coding Style & Naming Conventions
- Swift 5+, 4‑space indentation; keep lines readable (~120 cols).
- Types: PascalCase (`NoteCard`, `ThemeManager`); methods/vars: camelCase; enum cases: lowerCamelCase.
- One primary type per file; filename matches type (e.g., `Note.swift`).
- Organize UI by feature: shared UI in `Views/Components`, screens in `Views/Screens`.
- No linter configured; follow Swift API Design Guidelines and keep public APIs documented.

## Testing Guidelines
- Framework: `XCTest`. Create a `NotyTests` target under `Noty.xcodeproj`.
- File naming: `FeatureNameTests.swift`; test methods start with `test...`.
- Focus coverage on `Models` and `Utils`; add lightweight UI smoke tests if needed.
- Run via Xcode (Command-U) or CLI (see Test command above).

## Commit & Pull Request Guidelines
- History shows short, descriptive messages; no strict convention enforced.
- Prefer imperative mood and clear scope (e.g., `feat: add note search`, `fix(models): prevent empty titles`).
- PRs include: concise description, rationale, linked issues, and screenshots for UI changes.
- Before submitting: build succeeds, no unused assets, docs updated (e.g., guides under repo root).

## Security & Configuration Tips
- Do not commit secrets or credentials to `Info.plist` or source.
- Place new assets under `Noty/Ressources` or `Assets.xcassets`; avoid renaming folders (e.g., `Ressources`) without updating project settings.
