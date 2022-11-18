local GITHUB_REPOSITORY = "https://raw.githubusercontent.com/OMANIAOZANIA/OMANIAOZANIA-Productions/main/"
local GITHUB = {}

local getasset = getsynasset or getcustomasset
local httpRequest = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request

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

function GITHUB:GetCustomAsset(assetPath, cacheAsset)
-- assetPath: github repo (https://raw.githubusercontent.com/OMANIAOZANIA/OMANIAOZANIA-Productions/main/...)
-- assetPath: workspace ($ExploitFolder$/workspace/...)
    if (not cacheAsset) then
        return getasset(GITHUB_REPOSITORY .. assetPath:gsub("OMANIA_Productions/", ""))
    end

    local assetSavePath 
    if (not FUNCTION_isFile(assetPath:gsub("%%20", " "))) then
        spawn(function()
            local loadText = Instance.new("TextLabel")
            loadText.Size = UDim2.new(1, 0, 0, 36)
            loadText.Text = "Downloading " .. assetPath
            loadText.BackgroundTransparency = 1
            loadText.TextStrokeTransparency = 0
            loadText.TextSize = 30
            loadText.Font = Enum.Font.SourceSans
            loadText.TextColor3 = Color3.new(1, 1, 1)
            loadText.Position = UDim2.new(0, 0, 0, -36)
            loadText.Parent = game.CoreGui
            repeat wait() until FUNCTION_isFile(assetPath)
            loadText:Remove()
        end)
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
GITHUB:GetCustomAsset("OMANIA_Productions/BedWars%20WEED/assets/BedTP.png", true)
return GITHUB
