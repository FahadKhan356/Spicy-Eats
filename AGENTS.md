# Spicy Eats — working notes for agents

## Project

Flutter food-delivery app. State is Riverpod (`StateProvider` / `StateNotifierProvider`),
backend is Supabase (`lib/Supabse Backend/supabase_config.dart`, git-ignored local config),
plus local SQLite caches under `lib/features/Sqlight Database/`.

## Git workflow (required)

After **every** file change: verify, then `git add` only the files you touched,
`git commit`, and `git push origin main`. Never leave work uncommitted at the end of a task.

- Remote: `https://github.com/FahadKhan356/Spicy-Eats.git`, branch `main`.
- Commit messages follow Conventional Commits and stay lowercase and descriptive,
  e.g. `feat(favorites): ...`, `fix(ui): ...`, `chore(lint): ...`.
- Never stage build output or IDE noise: `ios/Podfile.lock`, `ios/Runner.xcodeproj/**`,
  `web/index.html`, `devtools_options.yaml`, `web_entrypoint.dart`.
- Never commit secrets. `lib/.env` and `lib/Supabse Backend/supabase_config.dart` are
  git-ignored on purpose.

## Before finishing a change

```
flutter analyze lib test
flutter test
```

Both must be clean. Add or update a test in `test/` for any behaviour you add or fix.
