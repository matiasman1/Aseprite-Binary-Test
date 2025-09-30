# ✨ Linux Aseprite Binary Demo

This extension showcases a native `.so` module running inside Aseprite **on Linux**—perfect for validating that Lua 5.4 can load linked libraries directly from an extension.

---

## 📦 Requirements

Install the Lua toolchain and headers that match Aseprite’s runtime:

```bash
# Debian/Ubuntu
sudo apt-get update
sudo apt-get install build-essential pkg-config liblua5.4-dev lua5.4

# Fedora
sudo dnf install @development-tools lua lua-devel
```

---

## 🛠️ Compile the module

Compile the `testmodule.so` shared library against Lua 5.4:

```bash
g++ -shared -fPIC \
  $(pkg-config --cflags lua5.4) \
  -o testmodule.so testprogram.cpp \
  $(pkg-config --libs lua5.4)
```

---

## 🛠️ Package the extension

After compilation, execute the included aseprite-extension packaging script

```bash
sudo chmod +x create_extension.sh
./create_extension.sh
```

## ✅ Lua 5.4 sanity check

Confirm the binary loads before launching Aseprite:

```bash
lua5.4 -e 'package.cpath="./?.so;"..package.cpath; local mod=require("testmodule"); print(mod.hello())'
```

You should see:

```
Hello from C++ side!
```

---

## 🖼️ Run inside Aseprite

1. Install the packaged extension (`Binary-test.aseprite-extension`).
2. Launch Aseprite and enable the extension.
3. Open the console (`Ctrl+Shift+`).
4. Run the script: it prints the greeting plus a `true` value, proving the `.so` was linked and executed inside Aseprite on Linux.

Enjoy your binary-powered Aseprite workflow! 🎉

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
