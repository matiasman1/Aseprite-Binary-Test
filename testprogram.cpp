extern "C" {
  #include <lua.h>
  #include <lauxlib.h>
  #include <lualib.h>
}

// A simple function to be called from Lua
static int l_hello(lua_State* L) {
  luaL_checkversion(L);  // optional sanity check
  lua_pushstring(L, "Hello from C++ side!");
  return 1;  // number of return values
}

// A test helper that just returns true so Lua callers can verify linkage
static int l_test(lua_State* L) {
  luaL_checkversion(L);
  lua_pushboolean(L, 1);
  return 1;
}

// The Lua module “open” function: must match the module name
extern "C" int luaopen_testmodule(lua_State* L) {
  // Create a new table to represent the module
  lua_newtable(L);

  // Add functions / fields to the module table
  lua_pushcfunction(L, l_hello);
  lua_setfield(L, -2, "hello");

  lua_pushcfunction(L, l_test);
  lua_setfield(L, -2, "test");

  // Optionally, set a version field
  lua_pushstring(L, "0.1");
  lua_setfield(L, -2, "version");

  // return the module table
  return 1;
}