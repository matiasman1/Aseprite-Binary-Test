local function readExtensionName()
  local defaultName = "binary-test"
  local possibleFiles = {"package.json"}

  local info = debug.getinfo(1, "S")
  if info and info.source then
    local sourcePath = info.source
    if sourcePath:sub(1, 1) == "@" then
      sourcePath = sourcePath:sub(2)
    end
    local dir = sourcePath:match("^(.*[/\\])")
    if dir then
      table.insert(possibleFiles, 1, dir .. "package.json")
    end
  end

  for _, path in ipairs(possibleFiles) do
    local f = io.open(path, "r")
    if f then
      local contents = f:read("*a")
      f:close()
      local name = contents:match('"name"%s*:%s*"([^"]+)"')
      if name and #name > 0 then
        return name
      end
    end
  end

  return defaultName
end

local extensionName = readExtensionName()
local homeDir = os.getenv("HOME") or "~"
local extensionRoot = homeDir .. "/.config/aseprite/extensions/" .. extensionName
local newEntries = {
  extensionRoot .. "/?.so",
  extensionRoot .. "/?/init.so"
}

local updatedCpath = package.cpath
for _, entry in ipairs(newEntries) do
  if not updatedCpath:find(entry, 1, true) then
    updatedCpath = entry .. ";" .. updatedCpath
  end
end
package.cpath = updatedCpath

local moduleName = "testmodule"
local mod = nil

local candidatePaths = {
extensionRoot .. "/" .. moduleName .. ".so",
extensionRoot .. "/lib/" .. moduleName .. ".so",
extensionRoot .. "/bin/" .. moduleName .. ".so",
"/usr/local/lib/lua/5.4/" .. extensionName .. "/" .. moduleName .. ".so",
"/usr/local/lib/lua/5.4/" .. moduleName .. ".so"
}

local loaderName = "luaopen_" .. moduleName
for _, path in ipairs(candidatePaths) do
    local loader, loadErr = package.loadlib(path, loaderName)
    if loader then
        local ok, result = pcall(loader)
        if ok then
        mod = result
        package.loaded[moduleName] = mod
        print("Loaded testmodule via package.loadlib from " .. path)
        break
        else
        print("Error invoking loader from " .. path .. ":", result)
        end
    elseif loadErr then
        print("package.loadlib failed on " .. path .. ":", loadErr)
    end
end


if mod then
  if mod.hello then
    print("mod.hello():", mod.hello())
  end

  if mod.test then
    print("mod.test():", mod.test())
  end
else
  print("Failed to load testmodule via all strategies")
end