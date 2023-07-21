--------------------------------
-- OMANIAOZANIA ProductionsTM --
--       Script Loader        --
--------------------------------
local is_executor_closure = is_syn_closure or is_fluxus_closure or is_sentinel_closure or is_krnl_closure or is_proto_closure or is_calamari_closure or is_electron_closure or is_elysian_closure or error("Unsupported client.")

--// VARIABLES (PUBLIC AND PRIVATE)
local player_character = game:GetService("Players")["LocalPlayer"].Character or game:GetService("Players")["LocalPlayer"].CharacterAdded:Wait()

getgenv().OMANIA_scriptLoader_hookPositionTo = player_character:WaitForChild("HumanoidRootPart").Position

--// R-AC 2023 (HYPERION) COUNTERMEASUERS
--// COUNTERMEASURE ACT I (FALSE HOOKING):
do
    for i,v in next, getconnections(game.DescendantAdded) do v:Disable() end
    local mt = getrawmetatable(game)
    local old = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(t, k)
        if k == "Position" then
            return getgenv().OMANIA_scriptLoader_hookPositionTo
                or player_character:WaitForChild("HumanoidRootPart").Position
        end
        return old(t, k)
    end)
end

--// COUNTERMEASURE ACT II (FAKE IMAGE CACHING):
local CoreGui = game:GetService("CoreGui")
local tbl = {}
for i,v in pairs(CoreGui.GetDescendants(CoreGui)) do
    if v.IsA(v, "ImageLabel") and v.Image:find('rbxasset://') then
           table.insert(tbl, v.Image)
       end
end

local function badFunc(func)
    if func == "PreloadAsync" or func == "preloadAsync" then
         return true
    end
    return false
end

local service;
service = hookfunction(game:GetService("ContentProvider").PreloadAsync, function(self, ...)
       local Args = {...}
       if not checkcaller() and type(Args[1]) == "table" and table.find(Args[1], CoreGui) then
           Args[1] = tbl
           return service(self, unpack(Args))
       end
   return service(self, ...)
end)
local __namecall;
__namecall = hookmetamethod(game, "__namecall", function(Self, ...)
   local Args = {...}
   local NamecallMethod = getnamecallmethod()
   if not checkcaller() and type(Args[1]) == "table" and table.find(Args[1], CoreGui) and Self == game.GetService(game, "ContentProvider") and badFunc(NamecallMethod) then
       Args[1] = tbl
       return __namecall(Self, unpack(Args))
   end
   return __namecall(Self, ...)
end)

--// REQUEST VARIABLES
local GITHUB_REPOSITORY = "https://raw.githubusercontent.com/OMANIAOZANIA/OMANIAOZANIA-Productions/main/"
local GITHUB = {}

local getasset = getsynasset or getcustomasset
local httpRequest = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request

--// PRIVATE FUNCTIONS
local FUNCTION_isFile = function(filePath)
    local success, response = pcall(function() return readfile(filePath) end)
    return success and response ~= nil
end
local FUNCTION_writeFile = function(filePath, fileContent)
    local folders = filePath:split("/")
    for index, folder in pairs(folders) do
        if (index > 1) then
            for previous = index - 1, 1, -1 do
                folder = folders[previous] .. "/" .. folder
            end
        end
        if (index >= #folders) then writefile(folder, fileContent) break end

        if (not isfolder(folder)) then
            makefolder(folder) end
    end
end

--// PUBLIC FUNCTIONS
function GITHUB:GetCustomAsset(assetPath, cacheAsset)
    if (not cacheAsset) then
        return getasset(GITHUB_REPOSITORY .. assetPath:gsub("OMANIA_Productions/", ""))
    end

    local assetSavePath 
    if (not FUNCTION_isFile(assetPath:gsub("%%20", " "))) then
        local requestAsset = httpRequest({
            Url = GITHUB_REPOSITORY  .. assetPath:gsub("OMANIA_Productions/", ""),
            Method = "GET"
        })
        assetSavePath = assetPath:gsub("%%20", " ")
        FUNCTION_writeFile(assetSavePath, requestAsset.Body)
    end
    if (not assetSavePath) then
        return getasset(assetPath:gsub("%%20", " ")) end
    return getasset(assetSavePath)
end

return GITHUB
