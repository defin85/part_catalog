# Repository Guidelines

A concise guide for contributors to the Flutter app in this repo. Follow these practices to keep changes consistent and easy to review.

## Communication & Language
- Working language: Russian. Use Russian for issues, PR descriptions, commit messages, and general discussion. Keep code identifiers and external API names in English as appropriate.

## Project Structure & Module Organization
- Source: `lib/` (feature-first under `lib/features/<feature>/`, shared in `lib/core` and `lib/models`). Entry points: `lib/main.dart`, `lib/main_web.dart`, `lib/main_desktop_demo.dart`, `lib/main_simple_demo.dart`.
- Tests: `test/unit`, `test/widgets`, `test/integration` (+ helpers/fixtures/mocks). Mirror `lib/` paths; name files `*_test.dart`.
- Assets: `assets/` (declare in `pubspec.yaml`).
- Platforms: `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/`.
- Docs & tools: `docs/`, `source_doc/`, `analysis/`, `scripts/`.

## Build, Test, and Development Commands
- Install deps: `flutter pub get`
- Analyze lints: `flutter analyze`
- Format code: `dart format .`
- Organize imports: `dart run scripts/organize_imports.dart`
- Run (Chrome): `flutter run -d chrome`
- Run (desktop): `flutter run -d windows|macos|linux`
- Test all: `flutter test` (or `dart run test/run_all_tests.dart`)
- Build releases: `flutter build apk|ipa|macos|linux|windows|web`

## Coding Style & Naming Conventions
- Lints: see `analysis_options.yaml` and `flutter_lints` defaults.
- Indentation: 2 spaces; prefer trailing commas; use `final`/`const` when possible.
- Imports: absolute from `lib/`.
- Names: Classes `PascalCase`; methods/vars `camelCase`; constants `SCREAMING_SNAKE_CASE`.

## Testing Guidelines
- Framework: `flutter_test` with unit, widget, integration layers.
- Keep tests fast and isolated; prefer fakes over network/filesystem.
- Coverage: `flutter test --coverage`.
- Structure: mirror `lib/` directories; name tests `*_test.dart`.

## Commit & Pull Request Guidelines
- Commits: Conventional Commits (e.g., `feat: add filters`, `fix: handle null ids`, `docs: update README`). Use imperative mood.
- PRs: include problem/solution summary, linked issues, verification steps, and UI screenshots when relevant.
- Before opening a PR: ensure `flutter analyze` and `flutter test` pass, and run formatting/import organization.

## Security & Configuration Tips
- Do not commit secrets. Use `.env` (already git-ignored) and document required keys.
- Prefer compile-time flags via `--dart-define` for non-secret config.
