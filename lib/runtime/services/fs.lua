local lfs = require("lfs")

local FileSystemModule = {}
local FileSystemService
local Instance

function FileSystemModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  FileSystemService = Instance.new()
  FileSystemService.Name = "FileSystemService"

  function FileSystemService:GetFolder(Path, Recursive)
    Recursive = Recursive or false

    local Folder = Instance.new()
    local Files = lfs.dir(Path)
    for fileName in Files do
      local IFile = Instance.new()
      IFile.Name = Path
    end
  end

  return FileSystemService
end

return FileSystemModule
