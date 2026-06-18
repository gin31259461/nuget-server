# Lightweight NuGet and Symbol Server

## Scope

This repository wraps a BaGetter source checkout as a small private NuGet and
symbol server. Root files control local deployment. Treat `BaGetter/` as
vendored upstream code unless the task explicitly requires application changes.

## Key Paths

- `Makefile`: publish, run, publish-and-run, and clean commands.
- `appsettings.json`: deployment configuration copied to `bin/`.
- `migrations/setup.sql`: PostgreSQL user and database bootstrap.
- `data/`: local package storage; ignored except `.gitkeep`.
- `bin/`: generated publish output; ignored by git.
- `BaGetter/src/BaGetter/BaGetter.csproj`: runnable BaGetter web app.

## Commands

Run commands from the repository root.

```sh
make publish
make prun
make run
make clean
```

`make publish` restores and publishes the BaGetter app, then copies the root
`appsettings.json` to `bin/appsettings.json`.

Equivalent publish command:

```sh
dotnet publish BaGetter/src/BaGetter/BaGetter.csproj \
  --configuration Release \
  --output bin
```

## Runtime Defaults

- Target framework: `net9.0`
- URL: `http://localhost:8080`
- Database: PostgreSQL database `nuget`, user `bagetter`
- Package storage: `../data` relative to `bin/`
- Database migrations: applied by BaGetter on startup

## Editing Rules

- Keep root documentation and scripts concise and operational.
- Preserve ignore behavior for `bin/` and `data/`.
- Do not commit published binaries, package data, database files, or secrets.
- Prefer `make` targets for publish, run, and clean workflows.
- Use ASCII in project docs unless existing content requires otherwise.

## Verification

For documentation or script changes, run the lightest relevant dry run:

```sh
make -n publish
make -n run
make -n clean
```

For application changes under `BaGetter/`, run the relevant `dotnet build` or
`dotnet test` command before finishing.
