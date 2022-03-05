--!strict

-- Axis
-- Stephen Leitnick
-- March 05, 2022

export type ProviderLifecycleFn = (Provider) -> ()

export type Provider = {
	AxisName: string?,
	AxisPrepare: ProviderLifecycleFn,
	AxisStarted: ProviderLifecycleFn,
	AxisExtensions: {Extension}?,
	[any]: any,
}

export type Extension = {
	BeforePrepare: ProviderLifecycleFn?,
	BeforeStarted: ProviderLifecycleFn?,
	[any]: any,
}

local Axis = {}

Axis._Providers = {}
Axis._Extensions = {}
Axis._Starting = false
Axis._Started = false
Axis._Awaiting = {}

function Axis:_RunExtensions(funcName: string, provider: Provider)
	local function Run(extension: Extension)
		local func = extension[funcName]
		if typeof(func) == "function" then
			func(provider)
		end
	end
	for _,extension: Extension in ipairs(self._Extensions) do
		Run(extension)
	end
	if provider.AxisExtensions then
		for _,extension: Extension in ipairs(provider.AxisExtensions) do
			Run(extension)
		end
	end
end

function Axis:AddExtension(extension: Extension): Extension
	if self._Started or self._Starting then
		error("Cannot add extensions after Axis has started", 2)
	end
	table.insert(self._Extensions, extension)
	return extension
end

function Axis:AddProvider(provider: Provider): Provider
	if self._Started or self._Starting then
		error("Cannot add providers after Axis has started", 2)
	elseif table.find(self._Providers, provider) ~= nil then
		error("Provider already exists", 2)
	end
	table.insert(self._Providers, provider)
	return provider
end

function Axis:Start()

	if self._Started or self._Starting then
		error("Axis already started", 2)
	end
	self._Starting = true

	local numProviders = #self._Providers
	local prepareDone = 0

	-- Call all AxisPrepare methods:
	local thread = coroutine.running()
	for _,provider: Provider in ipairs(self._Providers) do
		if typeof(provider.AxisPrepare) == "function" then
			task.spawn(function()
				self:_RunExtensions("BeforePrepare", provider)
				if provider.AxisName then
					debug.setmemorycategory(provider.AxisName)
				end
				provider:AxisPrepare()
				prepareDone += 1
				if prepareDone == numProviders then
					if coroutine.status(thread) == "suspended" then
						task.spawn(thread)
					end
				end
			end)
		end
	end

	-- Await all AxisPrepare methods to be completed:
	if numProviders ~= prepareDone then
		coroutine.yield(thread)
	end

	-- Call all AxisStarted methods:
	for _,provider: Provider in ipairs(self._Providers) do
		if typeof(provider.AxisStarted) == "function" then
			task.spawn(function()
				self:_RunExtensions("BeforeStarted", provider)
				if provider.AxisName then
					debug.setmemorycategory(provider.AxisName)
				end
				provider:AxisStarted()
			end)
		end
	end

	-- Resume awaiting threads:
	for _,awaitingThread in ipairs(self._Awaiting) do
		task.defer(awaitingThread)
	end

	self._Starting = false
	self._Started = true

end

function Axis:AwaitStart()
	if not self._Started then return end
	table.insert(self._Awaiting, coroutine.running())
	coroutine.yield()
end

function Axis:OnStart(callback: () -> ())
	if not self._Started then
		task.spawn(callback)
		return
	end
	local thread = coroutine.create(callback)
	table.insert(self._Awaiting, thread)
end

return Axis
