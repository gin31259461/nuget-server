PROJECT := BaGetter/src/BaGetter/BaGetter.csproj
CONFIG_FILE := appsettings.json
BIN_DIR := bin
APP_DLL := BaGetter.dll

ifdef COMSPEC
SHELL := powershell.exe
.SHELLFLAGS := -NoProfile -ExecutionPolicy Bypass -Command
copy_file = Copy-Item -LiteralPath "$(1)" -Destination "$(2)" -Force
remove_dir = if (Test-Path -LiteralPath "$(1)") { Remove-Item -LiteralPath "$(1)" -Recurse -Force }
run_app = Set-Location -LiteralPath "$(BIN_DIR)"; dotnet "$(APP_DLL)"
else
copy_file = cp "$(1)" "$(2)"
remove_dir = rm -rf "$(1)"
run_app = cd "$(BIN_DIR)" && dotnet $(APP_DLL)
endif

.PHONY: publish run clean

publish:
	dotnet restore "$(PROJECT)"
	dotnet publish "$(PROJECT)" --configuration Release --output "$(BIN_DIR)"
	$(call copy_file,$(CONFIG_FILE),$(BIN_DIR)/appsettings.json)

prun: publish
	$(run_app)

run:
	$(run_app)

clean:
	dotnet clean "$(PROJECT)" --configuration Release
	$(call remove_dir,$(BIN_DIR))
