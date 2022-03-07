---
sidebar_position: 2
---

# Providers

A provider in its simplest form may look like this:

```lua
local MyProvider = {}

-- AxisName is optional, but is used to add a memory category in the developer console
MyProvider.AxisName = "MyProvider"

-- AxisPrepare is called on all providers when Axis:Start() is called
function MyProvider:AxisPrepare()
end

-- After all AxisPrepare methods are done on all providers, AxisStarted will be called
function MyProvider:AxisStarted()
end

return MyProvider
```

To add a provider to Axis, call the `AddProvider` method:

```lua
Axis:AddProvider(MyProvider)
```

## Making it useful

Providers are just tables. As such, developers can add whatever is desired to a provider table. For instance, here is an example of a provider that does simple math:

```lua
local MathProvider = {}

function MathProvider:AxisPrepare() end
function MathProvider:AxisStarted() end

function MathProvider:Add(n1: number, n2: number): number
	return n1 + n2
end
```

And now other code can call the provider:

```lua
local result = MathProvider:Add(10, 20)
print(result) --> 30
```

Of course, a module like above could exist as a standalone ModuleScript without any need to be a provider. Providers are usually more complex systems that benefit from being contained. For instance, there could be a provider that handles player data.

## Access a provider from another provider

It is common for one provider to use another. As stated earlier, providers are just tables. As such, there is no trickery in using one provider from another. Simply reference the provider table and use it as desired. _However_, providers should respect the lifecycle methods. Providers should _not_ access other providers until the `AxisStarted` method has been called.

```lua
local AnotherProvider = require(somewhere.AnotherProvider) -- Get the other provider

local MyProvider = {}

function MyProvider:AxisPrepare()
	-- Not safe to use AnotherProvider because we can't guarantee it is ready yet
end

function MyProvider:AxisStarted()
	-- We can now guarantee that AnotherProvider:AxisPrepare() has been called and completed.
	-- It is now safe to use AnotherProvider.
	AnotherProvider:DoSomething()
end

return MyProvider
```

## Avoid Strong Coupling

Coupling occurs when pieces of code require other pieces of code. Such dependencies are unavoidable in many use-cases. However, providers are designed to be top-level singletons. As such, they should be designed as standalone as possible. While there are definitely cases where providers will need to access other providers (hence the lifecycle methods existing in the first place), it is better to design around such necessities.
