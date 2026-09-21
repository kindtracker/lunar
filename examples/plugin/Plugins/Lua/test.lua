local TestModule = {}

function TestModule.new()
  return {
    TestVaalue = "Cat", -- Vaalue is not a typo.
  }
end

function TestModule:InitPlugin()
  Instance:RegisterClass("TestClass", TestModule, Instance)
end

return TestModule
