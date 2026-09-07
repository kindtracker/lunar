local FileSystemService = Lunar:GetService("FileSystemService")
local ConsoleService = Lunar:GetService("ConsoleService")
ConsoleService.LogFormat = "{MESSAGE}"

local LogsFile = FileSystemService:Open("Workspace/Logs", "Logs", "a+")
LogsFile:Write("Opened in " .. os.time() .. "\n")
local Logs = LogsFile:Read("*a")

-- Remove last new line
ConsoleService:Log(Logs:sub(1, -2))
