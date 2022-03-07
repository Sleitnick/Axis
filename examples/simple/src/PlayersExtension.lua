-- An extension which binds OnPlayerAdded and OnPlayerRemoving methods of a provider
-- to the PlayerAdded and PlayerRemoving events.

local Players = game:GetService("Players")

local PlayersExtension = {}

function PlayersExtension.BeforePrepare(provider)

	-- Bind to OnPlayerAdded if the provider has that function
	if type(provider.OnPlayerAdded) == "function" then
		Players.PlayerAdded:Connect(function(player)
			provider:OnPlayerAdded(player)
		end)
		-- Capture any players that might have been in the game before the extension was invoked:
		for _,player in ipairs(Players:GetPlayers()) do
			task.spawn(function()
				provider:OnPlayerAdded(player)
			end)
		end
	end

	-- Bind to OnPlayerRemoving if the provider has that function
	if type(provider.OnPlayerRemoving) == "function" then
		Players.PlayerRemoving:Connect(function(player)
			provider:OnPlayerRemoving(player)
		end)
	end

end

function PlayersExtension.BeforeStarted(_provider)
	
end

return PlayersExtension
