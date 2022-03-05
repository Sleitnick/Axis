[![CI](https://github.com/Sleitnick/Axis/actions/workflows/ci.yaml/badge.svg)](https://github.com/Sleitnick/Axis/actions/workflows/ci.yaml)
[![CD](https://github.com/Sleitnick/Axis/actions/workflows/cd.yaml/badge.svg)](https://github.com/Sleitnick/Axis/actions/workflows/cd.yaml)

# Axis

Axis is a provider framework for the Roblox ecosystem.

## Provider Example

Providers are simply tables with a name and a couple lifecycle methods.

```lua
local MyProvider = {}

function MyProvider:AxisPrepare()
	print("Prepare the provider")
end

function MyProvider:AxisStarted()
	print("Started")
end

return MyProvider
```

Providers must be explicitly added into Axis via `Axis:AddProvider()`. Once all providers are added, `Axis:Start()` will kick off the lifecycle methods of the providers.

A script to bootstrap Axis might look like this:

```lua
local Axis = require(somewhere.Axis)
local MyProvider = require(somewhere.MyProvider)

Axis:AddProvider(MyProvider)

Axis:Start()
```

## Using multiple providers

Because providers are just tables, it is easy for one provider to use another. Simply get a reference to the other provider (e.g. requiring its ModuleScript) and then access it after AxisStarted has fired. For example:

```lua
local MyProvider = require(somewhere.MyProvider) -- Grab the other provider

local AnotherProvider = {}

function AnotherProvider:AxisPrepare()
	-- Other providers are NOT safe to use here, because there's no guarantee
	-- that they have all been prepared yet. Wait until AxisStarted.
end

function AnotherProvider:AxisStarted()
	-- Other providers are safe to use once the AxisStarted method fires.
	MyProvider:DoSomething()
end
```

## Extensions

Axis providers are very simple. In order to expand the possibilities of providers, extensions can be added. Extensions can be added at the Axis level (e.g. apply to all providers) or at the individual provider level.

Extensions allow code to run for a provider before certain lifecycle methods. This can be used to transform, inject, create networking, or do whatever is required to set up the providers for certain use-cases.

Below is an example of a simple logger extension:

```lua
local Axis = require(somewhere.Axis)

Axis:AddExtension {
	-- Assumes that a custom 'Name' field has been added to all providers:
	BeforePrepare = function(provider)
		print("Preparing provider", provider.Name)
	end,
	BeforeStarted = function(provider)
		print("Starting provider", provider.Name)
	end,
}
```

Here is a similar example, but on a provider:

```lua
local MyProvider = {}

MyProvider.AxisExtensions = {
	{
		BeforePrepare = function(provider)
			print("BeforePrepare MyProvider")
		end,
		BeforeStarted = function(provider)
			print("BeforeStarted MyProvider")
		end,
	},
}
```

Extensions will run in the order of which they were added. Axis-level extensions run before provider-level extensions.

## Memory categories

Because Axis providers are started from one source, the default memory label within the Developer Console will appear the same for all providers. To solve this, Axis will automatically assign a memory category if the `AxisName` field is set.

```lua
local MyProvider = {}

MyProvider.AxisName = "MyProvider"
```

When MyProvider is prepared/started, any memory usage will show up within the MyProvider label in the Developer Console memory section.

If the script being used to bootstrap Axis is grabbing each provider from its own ModuleScript, then a simple way to inject this is to set the `AxisName` property to the ModuleScript's name. For example:

```lua
for _,module in ipairs(somewhere.MyProviderModules:GetChildren()) do
	local provider = require(module)
	provider.AxisName = module.Name -- Inject name
	Axis:AddProvider(provider)
end
```
