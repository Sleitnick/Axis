---
sidebar_position: 1
---

# Getting Started

Axis is a provider framework for the Roblox ecosystem. Providers are simple structures that provide high-level encapsulation of logic, along with lifecycle methods to help accommodate communication between each other.

A provider in its simplest form may look like this:

```lua
local MyProvider = {}

function MyProvider:AxisPrepare()
end

function MyProvider:AxisStarted()
end

return MyProvider
```

To add a provider to Axis, call the `AddProvider` method:

```lua
Axis:AddProvider(MyProvider)
```

Because providers are just Lua tables, developers can add any desired methods and functionality to them as needed. The two `AxisPrepare` and `AxisStarted` methods are lifecycle methods that Axis will call during startup. `AxisPrepare` is called first, and should be used to prepare the provider for use. `AxisStarted` is called after _all_ other providers have completed their `AxisPrepare` methods. At this point, it is safe to assume that other providers can be used from within a provider.

Typically, there will be one script per server/client that will gather all providers and extensions, and then add them to Axis. Once all providers and extensions are added, Axis can be started.
