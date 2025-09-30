# Aseprite Lua C++ Module Test

This is a simple C++ module that can be compiled as a shared library and loaded into Aseprite's Lua scripting environment.

## What it does

The module exports two functions:

- `hello()` &rarr; returns the string `"Hello from C++ side!"`
- `test()` &rarr; returns `true`, allowing you to confirm that the binary module was loaded correctly

## Prerequisites

- C++ compiler (g++ or clang++)
- Lua development headers
- Aseprite with Lua scripting support

## Installation

### Ubuntu/Debian
```bash
sudo apt-get install lua5.4-dev build-essential pkg-config
```

If `lua5.4-dev` is not available for your distribution, install the closest Lua 5.4 development package and adjust the `pkg-config` invocations accordingly.
### Fedora/CentOS
```bash
sudo dnf install lua-devel gcc-c++ pkgconf-pkg-config
```

### macOS
```bash
brew install lua
```

## Compilation

### Build the shared library (Lua 5.4 on Linux)

This repository targets Lua 5.4 (the version bundled with modern Aseprite builds). Compile the module into a shared object using `pkg-config`:

```bash
g++ -shared -fPIC \
  $(pkg-config --cflags lua5.4) \
  -o testmodule.so testprogram.cpp \
  $(pkg-config --libs lua5.4)
```

If `pkg-config --cflags lua5.4` fails, install the `lua5.4-dev` package (Debian/Ubuntu) or adjust the include/library paths to match your system. You can discover header locations with:

```bash
find /usr -name "lua.h" 2>/dev/null
```

### Windows (MinGW)
```bash
g++ -shared -o testmodule.dll testprogram.cpp -llua
```

## Installation target (Linux)

Copy the compiled module to the Lua package directory that Aseprite searches on Linux:

```bash
sudo mkdir -p /usr/local/lib/lua/5.4/binary-test
sudo cp testmodule.so /usr/local/lib/lua/5.4/binary-test/
```

The compiled library must be named `testmodule.so`. This extension prepends its installation folder to `package.cpath`, so the module is resolved directly from the extension directory.

## Usage in Aseprite

The included `main.lua` file demonstrates how to load and exercise the native module from Aseprite's Lua runtime:

```lua
local ok, mod = pcall(require, "testmodule")
if not ok then
  print("Failed to load C++ module:", mod)
  return
end

print(mod.hello())        -- prints: Hello from C++ side!
print(mod.test())         -- prints: true
```

When you run the extension inside Aseprite, you should see both outputs in the console, confirming that the shared library was located and the functions were exported correctly.

## File Structure

```
/home/usuario/Documentos/Aseprite Binary Test/
├── testprogram.cpp    # Source code
├── testmodule.so      # Compiled shared library (after compilation)
└── README.md          # This file
```

## Troubleshooting

- If you get "lua.h: No such file or directory", install Lua dev headers and point the include path as shown above.
- If pkg-config fails on Windows, use explicit include (-I) and lib (-L) paths or MSVC project settings.
- Verify the exported symbol exists in the DLL:
  - On Windows, use dumpbin /EXPORTS testmodule.dll (MSVC tools) or objdump -x testmodule.dll (mingw) to confirm luaopen_testmodule is exported.
- If luaopen symbol is not exported, ensure the code uses an export (see DLLEXPORT macro in testprogram.cpp).

## Copying files with cp

Simple copy:
```bash
cp source_file destination_file
# Example:
cp testmodule.so /path/to/aseprite/scripts/testmodule.so
```

Copy into a directory (keep same filename):
```bash
cp testmodule.so /path/to/aseprite/scripts/
```

Recursive copy (directories):
```bash
cp -r my_folder /path/to/destination/
```

Preserve attributes (mode, ownership, timestamps):
```bash
cp -a source_dir/ /path/to/destination/
```

Force copy and prompt before overwrite:
```bash
cp -i source_file destination_file  # prompt
cp -f source_file destination_file  # force
```

Copy with sudo if writing to protected locations:
```bash
sudo cp testmodule.so /usr/local/share/aseprite/scripts/
```

Notes:
- On Windows, use File Explorer or PowerShell's Copy-Item instead of cp.
- Ensure the destination path exists; create it with mkdir -p if needed:
```bash
mkdir -p /path/to/aseprite/scripts
cp testmodule.so /path/to/aseprite/scripts/
```
