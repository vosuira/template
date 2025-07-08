local TestModule = {}

TestModule.OnPlayerAdded = function()
	print("errr")
end

TestModule.OnPlayerRemoving = function()
	print("meow")
end

return TestModule
