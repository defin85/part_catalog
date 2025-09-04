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

## Entry Points & Targets
- Web demo: `flutter run -d chrome -t lib/main_web.dart`
- Desktop demo: `flutter run -d windows|macos|linux -t lib/main_desktop_demo.dart`
- Simple demo: `flutter run -t lib/main_simple_demo.dart`

## Code Generation
- One-off: `dart run build_runner build -d`
- Watch mode: `dart run build_runner watch -d`
- Slang i18n (if needed explicitly): `dart run slang_build_runner`

## Localization (Slang)
- Strings live under `lib/core/i18n/**` and generate `lib/core/i18n/strings.g.dart`.
- Use `TranslationProvider` and `AppLocale` utilities; see `lib/core/widgets/language_switcher.dart`.
- Codegen runs via build_runner; run commands above if generated files are missing.

## Analyzer Notes
- Tests are currently excluded in `analysis_options.yaml` (`test/**`). This is intentional to reduce noise.
- If you want analyzer coverage for tests, remove the exclusion locally before committing changes.

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

## Автоматизация (Codex CLI)
- Один патч на задачу: при внесении нескольких изменений в рамках одной логической задачи агрегируйте их в один вызов `apply_patch` (один общий патч с несколькими операциями Add/Update/Delete). Это уменьшит количество подтверждений и упростит ревью.
- Группируйте связанные правки: избегайте цепочки мелких патчей; используйте один патч с несколькими файловыми изменениями, если они относятся к одной цели.
- Исключения: для крупных и несвязанных изменений используйте отдельные патчи с кратким объяснением причины разбиения.
- Сандбокс: учитывайте `--sandbox workspace-write` — изменяйте только файлы внутри рабочей директории репозитория.
