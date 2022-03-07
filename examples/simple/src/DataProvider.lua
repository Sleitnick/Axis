-- Simple provider that keeps track of non-persistent data while the player is in the game

local DataProvider = {}

DataProvider.AxisName = "DataProvider"

DataProvider._PerPlayerData = {}

DataProvider._ThreadsAwaitingData = {}

-- Resume any waiting threads with the given data
function DataProvider:_ResumeAwaitingThreads(player: Player, data)
	local threads = self._ThreadsAwaitingData[player]
	if not threads then return end
	for _,thread in ipairs(threads) do
		task.spawn(thread, data)
	end
	self._ThreadsAwaitingData[player] = nil
end

-- Hooked up by the PlayersExtension
function DataProvider:OnPlayerAdded(player: Player)
	self._PerPlayerData[player] = {}
	self:_ResumeAwaitingThreads(player, self.PerPlayerData[player])
end

-- Hooked up by the PlayersExtension
-- Clears the data and any awaiting threads
function DataProvider:OnPlayerRemoving(player: Player)
	self._PerPlayerData[player] = nil
	self:_ResumeAwaitingThreads(player, nil)
end

-- Get the data for the player (if any)
function DataProvider:GetPlayerData(player: Player)
	return self._PerPlayerData[player]
end

-- Yield the current thread until the player's data is available
function DataProvider:AwaitPlayerData(player: Player)
	if player.Parent == nil then
		return nil
	end
	local data = self:GetPlayerData(player)
	if data ~= nil then
		return data
	end
	if not self._ThreadsAwaitingData[player] then
		self._ThreadsAwaitingData[player] = {}
	end
	table.insert(self._ThreadsAwaitingData[player], coroutine.running())
	return coroutine.yield()
end

function DataProvider:AxisPrepare()
	
end

function DataProvider:AxisStarted()
	
end

return DataProvider
