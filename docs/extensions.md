---
sidebar_position: 3
---

# Extensions

Extensions allow the capabilities of providers to be expanded. By tying into the lifecycle methods of all providers, extensions let developers build upon what providers can do to whatever best fits the given use-cases. For example, an extension could be created to add networking so that communication between providers could exist between the server and client.

## Making an Extension

Extensions are easy to make and run in the context of each provider. At the core, extensions are simply a collection of functions that run before the lifecycle methods of providers. Extensions should be generic (in the sense that they don't care about what the provider does).

A bare-bones extension looks like the following:

```lua
local SomeExtension = {}

-- Runs directly before AxisPrepare is called on the provider
function SomeExtension.BeforePrepare(provider)
end

-- Runs directly before AxisStarted is called on the provider
function SomeExtension.BeforeStarted(provider)
end
```

The extension functions can then do whatever is necessary to the given `provider`.

## Extension Levels
Extensions can be added at two separate levels.

### Axis-level Extensions
Adding extensions at the Axis-level allows extensions to be applied to all providers in Axis.

```lua
Axis:AddExtension(SomeExtension)
```

### Provider-level Extensions
To apply an extension to an individual provider, an extension can be explicitly added to the provider. This is done by listing the extensions in the provider's `AxisExtension` table:

```lua
local MyProvider = {}

MyProvider.AxisExtensions = {SomeExtension01, SomeExtension02, ...}
```

## Execution Order

Extensions run in the order that they were added. Before a provider lifecycle method is run, all Axis-level extensions (i.e. added with `Axis:AddExtension`) are run. Directly after, all provider-level extensions are run. All extensions are run in series, each one waiting for the previous one to complete. The provider's lifecycle method will not run until all extensions are executed successfully.

For example, consider the following:

```lua
local MyProvider = {}

MyProvider.AxisExtensions = {Extension01, Extension02}

Axis:AddExtension(Extension03)
Axis:AddExtension(Extension04)

Axis:Start()

-- Extensions above will execute in the following order for MyProvider:
-- 1. Extension03
-- 2. Extension04
-- 3. Extension01
-- 4. Extension02
```

## Examples

### Logging

While `AxisName` is optional for providers, here's a simple extension that tries to log out when a provider starts up.

```lua
local LogExtension = {}

function LogExtension.BeforePrepare(provider)
	print("Provider BeforePrepare", provider.AxisName)
end

function LogExtension.BeforeStarted(provider)
	print("Provider BeforeStarted", provider.AxisName)
end
```

### Player Injection

Injecting the local player into a provider isn't really that useful, but provides an example of property injection to providers. In this example, the extension will set the provider's `Player` property to the LocalPlayer (if it's on the client):

```lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local PlayerInjectionExtension = {}

function PlayerInjectionExtension.BeforePrepare(provider)
	if RunService:IsClient() then
		provider.Player = Players.LocalPlayer
	end
end
```
