# AGENTS.md

Guidance for coding agents working in this repository.

## Project

This repo wraps a BaGetter source checkout as a lightweight private NuGet and
symbol server. The root project files define local deployment behavior; avoid
unrelated changes inside the upstream `BaGetter/` source unless the task
explicitly requires it.

## Important Paths

- `Makefile` - cross-platform publish, run, and clean commands.
- `appsettings.json` - deployment configuration copied to `bin/`.
- `migrate/setup.sql` - PostgreSQL user/database bootstrap.
- `data/` - local package storage, ignored except `.gitkeep`.
- `bin/` - generated publish output, ignored by git.
- `BaGetter/src/BaGetter/BaGetter.csproj` - runnable web app project.

## Commands

Use these from the repository root:

```sh
make publish
make run
make clean
```

Equivalent publish command:

```sh
dotnet publish BaGetter/src/BaGetter/BaGetter.csproj \
  --configuration Release \
  --output bin
```

After publishing, root `appsettings.json` must exist at `bin/appsettings.json`.

## Runtime Assumptions

- Target framework is `net9.0`.
- Server listens on `http://localhost:8080` by default.
- PostgreSQL connection defaults to database `nuget`, user `bagetter`.
- Filesystem package storage defaults to `../data` relative to `bin/`.
- BaGetter applies application database migrations on startup.

## Editing Rules

- Keep root docs and scripts concise and operational.
- Preserve generated-output ignores for `bin/` and `data/`.
- Do not commit published binaries, package data, database files, or secrets.
- Treat `BaGetter/` as vendored upstream source unless asked to modify it.
- Prefer `make` targets for publish/run/clean verification.
- Use ASCII in project docs unless there is a clear reason not to.

## Verification

For doc or script changes, run the lightest relevant check:

```sh
make -n publish
make -n run
make -n clean
```

For application changes under `BaGetter/`, run the relevant `dotnet test` or
`dotnet build` command before finishing.
