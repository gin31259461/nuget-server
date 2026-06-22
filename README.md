# Lightweight NuGet and Symbol Server

This repository publishes a local
[BaGetter](https://github.com/bagetter/BaGetter) checkout as a private NuGet
and symbol server. It uses PostgreSQL for metadata and the local filesystem for
package storage.

## Requirements

- .NET 9 SDK/runtime
- GNU Make
- PostgreSQL

## Project Layout

- `BaGetter/` - BaGetter source checkout.
- `appsettings.json` - server configuration copied into `bin/` on publish.
- `migrations/setup.sql` - PostgreSQL user and database bootstrap script.
- `data/` - local package storage.
- `bin/` - generated publish output.

## Configuration

The default configuration in `appsettings.json` uses:

- URL: `http://localhost:8080`
- Database: PostgreSQL database `nuget`, user `bagetter`
- Package storage: `../data` relative to `bin/`

Edit `appsettings.json` before publishing to change the port, database, API key,
or storage path.

### How to add this source

Windows:

1. edit `$HOME/AppData/Roaming/NuGet/NuGet.Config`

1. add the following package source:

    ```xml
    <packageSources>
        <add key="nuget.wke" value="http://<URL>:8080/v3/index.json" allowInsecureConnections="True" />
    </packageSources>
    ```

## Database Setup

Create the local PostgreSQL user and database:

```sh
psql -U postgres -h localhost -p 5432 -f ./migrations/setup.sql
```

BaGetter applies its application migrations when the server starts.

## Commands

```sh
make publish  # publish BaGetter into bin/
make prun     # publish, then run the server
make run      # run the published server from bin/
make clean    # remove generated output
```

The server listens on `http://localhost:8080` by default.

## Restore Existing Packages

After the server is running, push existing packages from `data/packages` back
into the package index:

```sh
dotnet nuget push "data/packages/**/*.nupkg" \
  --source http://localhost:8080/v3/index.json \
  --skip-duplicate
```

## Register as Windows Service

1. install [servy][]

    ```bash
    winget install servy
    ```

2. open servy gui and setup fields

[servy]: https://github.com/aelassas/servy
