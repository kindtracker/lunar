local TestModule = {}

function TestModule.new()
  return {
    TestVaalue = "Cat", -- Vaalue is not a typo.
  }
end

Instance:RegisterClass("TestClass", TestModule, Instance)
