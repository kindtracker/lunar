local Tests = {
  "tests/core/instance/create.lua",
  "tests/core/instance/parent.lua",
  "tests/core/service/getservice.lua",
  "tests/core/datatypes/color3/create.lua",
  "tests/core/datatypes/color3/fromrgb.lua",
  "tests/core/datatypes/color3/fromhex.lua",
  "tests/core/datatypes/color3/fromhsv.lua",
  "tests/core/datatypes/color4/create.lua",
  "tests/core/datatypes/color4/fromrgba.lua",
  "tests/core/datatypes/color4/fromhex.lua",
  "tests/core/datatypes/color4/fromhsv.lua",
}

for _, Test in ipairs(Tests) do
  local TestMessage, ErrorMessage = pcall(dofile, Test)

  if type(TestMessage) == "boolean" and TestMessage then
    print(string.format("[PASS] Test %s", Test))
  elseif TestMessage == nil then
    print(string.format("[FAIL] Test %s (crash) | %s", Test, ErrorMessage))
  elseif TestMessage then
    print(string.format("[FAIL] Test %s (error) | %s", Test, TestMessage))
    print(ErrorMessage)
  end
end
