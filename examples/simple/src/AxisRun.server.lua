local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Axis = require(ReplicatedStorage.Packages.Axis)
local PlayersExtension = require(ServerScriptService.Source.PlayersExtension)

-- Add extensions
Axis:AddExtension(PlayersExtension)

-- Add providers (in this case, load modules whose names end with "Provider")
for _,module in ipairs(ServerScriptService.Source:GetChildren()) do
	if module:IsA("ModuleScript") and module.Name:match("Provider$") then
		local provider = require(module)
		Axis:AddProvider(provider)
	end
end

print("Axis starting...")
Axis:Start()
print("Axis started")
