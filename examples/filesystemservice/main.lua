local FileSystemService = Lunar:GetService("FileSystemService")

local LogsFile = FileSystemService:Open("Workspace/Logs", "Logs", "a+")
LogsFile:Write("Opened in " .. os.time() .. "\n")
local Logs = LogsFile:Read("*a")

-- Remove last new line
print(Logs:sub(1, -2))
