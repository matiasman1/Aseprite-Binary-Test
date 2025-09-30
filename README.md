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
3. It prints the greeting plus a `true` value, proving the `.so` was linked and executed inside Aseprite on Linux.
4. Disable & Enable the extension in the extensions menu (ctrl+k -> Extensions) to see the output again (re-runs the extension)

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
