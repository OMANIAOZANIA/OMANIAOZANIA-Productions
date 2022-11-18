local GITHUB_REPOSITORY = "https://raw.githubusercontent.com/OMANIAOZANIA/OMANIAOZANIA-Productions/main/"
local GITHUB = {}

local getasset = getsynasset or getcustomasset
local httpRequest = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request

local FUNCTION_isFile = function(file)
    local success, response = pcall(function() return readfile(file) end)
    return success and response ~= nil
end

function GITHUB:GetCustomAsset(assetPath, cacheAsset)
-- assetPath: github repo (https://raw.githubusercontent.com/OMANIAOZANIA/OMANIAOZANIA-Productions/main/...)
-- assetPath: workspace ($ExploitFolder$/workspace/...)
    spawn(function()
        if (not cacheAsset) then
            return getasset(GITHUB_REPOSITORY .. assetPath:gsub("OMANIA_Productions/", ""))
        end

        local assetSavePath
        if (not FUNCTION_isFile(assetPath)) then
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
            writefile(assetSavePath, requestAsset.Body)
        end
	    print(assetSavePath)
        local assetCache = getasset(assetSavePath)
        return assetCache
    end)
end

return GITHUB
