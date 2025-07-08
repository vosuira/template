local Promise = require("@Packages/promise")

type EventBinding = {
	Event: RBXScriptSignal,
	Method: string,
}

type Module = {
	[string]: any,
}

export type Framework = {
	__index: Framework,
	_modules: { [string]: Module },
	_modulePath: Instance,
	_lifecycles: { string },
	_eventBindings: { [string]: EventBinding },
	_completedLifecycles: { [string]: boolean },
	_connections: { [string]: { RBXScriptConnection } },
	
	New: (modulePath: Instance, lifecycles: { string }?) -> Framework,
	_loadModules: (self: Framework) -> (),
	_runLifecycle: (self: Framework, methodName: string) -> any,
	Bind: (self: Framework, eventName: string, event: RBXScriptSignal, methodName: string) -> Framework,
	Connect: (self: Framework) -> Framework,
	Disconnect: (self: Framework, eventName: string?) -> Framework,
	Run: (self: Framework, customLifecycles: { string }?) -> any,
	GetModule: (self: Framework, name: string) -> Module?,
	GetAllModules: (self: Framework) -> { [string]: Module },
}

local Framework: Framework = {} :: Framework
Framework.__index = Framework

function Framework.New(modulePath: Instance, lifecycles: { string }?): Framework
	local self = setmetatable({}, Framework)
	self._modulePath = modulePath
	self._modules = {}
	self._lifecycles = lifecycles or { "Init", "Start" }
	self._eventBindings = {}
	self._completedLifecycles = {}
	self._connections = {}
	return self
end

function Framework:_loadModules(): ()
	local function loadRecursive(container: Instance)
		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("ModuleScript") then
				local success, result = pcall(require, child)
				if success and type(result) == "table" then
					self._modules[child.Name] = result
				elseif not success then
					error(`Framework: Failed to require module '{child.Name}' - {result}`, 0)
				else
					error(`Framework: Module '{child.Name}' must return a table, got {type(result)}`, 0)
				end
			elseif child:IsA("Folder") then
				loadRecursive(child)
			end
		end
	end
	
	loadRecursive(self._modulePath)
end

function Framework:_runLifecycle(methodName: string): any
	if self._completedLifecycles[methodName] then
		return Promise.resolve(self)
	end
	
	if next(self._modules) == nil then
		self:_loadModules()
	end
	
	local promises = {}
	
	for moduleName, module in pairs(self._modules) do
		if module[methodName] then
			table.insert(promises, Promise.new(function(resolve, reject)
				local success, result = pcall(module[methodName], module)
				if success then
					resolve(result)
				else
					reject(`Framework: {methodName} failed in module '{moduleName}' - {result}`)
				end
			end))
		end
	end
	
	return Promise.all(promises):andThen(function()
		self._completedLifecycles[methodName] = true
		return self
	end)
end

function Framework:Bind(eventName: string, event: RBXScriptSignal, methodName: string): Framework
	self._eventBindings[eventName] = {
		Event = event,
		Method = methodName,
	}
	return self
end

function Framework:Connect(): Framework
	if next(self._modules) == nil then
		self:_loadModules()
	end
	
	for eventName, binding in pairs(self._eventBindings) do
		if not self._connections[eventName] then
			self._connections[eventName] = {}
		end
		
		for moduleName, module in pairs(self._modules) do
			if module[binding.Method] then
				local connection = binding.Event:Connect(function(...)
					local success, result = pcall(module[binding.Method], module, ...)
					if not success then
						warn(`Framework: {binding.Method} failed in module '{moduleName}' - {result}`)
					end
				end)
				table.insert(self._connections[eventName], connection)
			end
		end
	end
	
	return self
end

function Framework:Disconnect(eventName: string?): Framework
	if eventName then
		local connections = self._connections[eventName]
		if connections then
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			self._connections[eventName] = {}
		end
	else
		for _, connections in pairs(self._connections) do
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
		end
		self._connections = {}
	end
	
	return self
end

function Framework:Run(customLifecycles: { string }?): any
	local lifecycles = customLifecycles or self._lifecycles
	
	local function runNext(index: number): any
		if index > #lifecycles then
			return Promise.resolve(self)
		end
		
		return self:_runLifecycle(lifecycles[index]):andThen(function()
			return runNext(index + 1)
		end)
	end
	
	return runNext(1)
end

function Framework:GetModule(name: string): Module?
	return self._modules[name]
end

function Framework:GetAllModules(): { [string]: Module }
	return self._modules
end

return Framework