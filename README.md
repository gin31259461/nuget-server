# Lightweight NuGet and Symbol Server

This repository packages [BaGetter](https://github.com/bagetter/BaGetter) as a
small private NuGet and symbol server using PostgreSQL and filesystem package
storage.

## Requirements

- .NET 9 SDK/runtime
- GNU Make
- PostgreSQL

## Layout

- `BaGetter/` - BaGetter source checkout.
- `appsettings.json` - local server configuration.
- `migrate/setup.sql` - PostgreSQL bootstrap script.
- `data/` - package storage directory.
- `bin/` - generated publish output, ignored by git.

## Configuration

The root `appsettings.json` is copied into `bin/` during publish. It configures:

- Server URL: `http://localhost:8080`
- Database: PostgreSQL database `nuget`, user `bagetter`
- Package storage: `../data`

Update `appsettings.json` before publishing if you need a different database,
port, API key, or storage path.

## Database Setup

Create the local PostgreSQL user and database:

```sh
psql -U postgres -h localhost -p 5432 -f ./migrate/setup.sql
```

BaGetter applies its own application migrations on startup.

## Commands

Publish BaGetter into `bin/`:

```sh
make publish
```

Publish and run the server:

```sh
make prun
```

Just run the server:

```sh
make run
```

Remove generated output:

```sh
make clean
```

## Restore Packages to DB

If you have existing packages in `data/packages`, you can restore them to the database with:

```sh
dotnet nuget push "data/packages/**/*.nupkg" --source http://localhost:8080/v3/index.json --skip-duplicate
```
