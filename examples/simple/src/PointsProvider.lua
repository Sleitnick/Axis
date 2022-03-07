local ServerScriptService = game:GetService("ServerScriptService")

local DataProvider = require(ServerScriptService.Source.DataProvider)

local PointsProvider = {}

function PointsProvider:OnPlayerAdded(player: Player)
	local data = DataProvider:AwaitPlayerData(player)
	if data == nil then return end
	data.Points = 0
end

function PointsProvider:AddPoints(player: Player, deltaPoints: number): number
	local data = DataProvider:GetPlayerData(player)
	if data == nil then return end
	data.Points += deltaPoints
	return data.Points
end

function PointsProvider:AxisPrepare()

end

function PointsProvider:AxisStarted()
	
end

return PointsProvider
