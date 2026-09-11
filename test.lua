local tests = {
  "tests/core/instance.lua",
}

for _, test in ipairs(tests) do
  local TestOk, ErrorMessage = pcall(dofile, test)

  if TestOk then
    print(string.format("[PASS] %s", test))
  else
    print(string.format("[FAIL] %s", test))
    print(ErrorMessage)
  end
end
