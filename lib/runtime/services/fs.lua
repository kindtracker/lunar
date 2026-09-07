local lfs = require("lfs")

local FileSystemModule = {}
local FileSystemService
local Instance

function FileSystemModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  FileSystemService = Instance.new()
  FileSystemService.Name = "FileSystemService"

  function FileSystemModule.__Lunar_Internal__Convert_Attrs__(Path, Name, Attributes)
    local ModeList = {
      ["directory"] = "Folder",
      ["file"] = "File",
      ["socket"] = "Socket",
      ["named pipe"] = "NamedPipe",
      ["char device"] = "CharDevice",
      ["block device"] = "BlockDevice",
      ["other"] = "Unknown"
    }
    local Lunar_Attributes = {
      Name = Name,
      Path = Path,
      Type = ModeList[Attributes.mode],
      Size = Attributes.size,
      ModificationTime = Attributes.modification,
      AccessTime = Attributes.access,
      ChangeTime = Attributes.change,
      Permissions = Attributes.permissions
    }

    for key, value in pairs(Attributes) do
      Lunar_Attributes["__Hidden_LFS__" .. key] = value
    end
  end

  function FileSystemService:GetFolder(Path, Recursive)
    Recursive = Recursive or false

    local Folder = Instance.new()
    local Files = lfs.dir(Path)
    for fileName in Files do
      local Attributes = FileSystemService:__Lunar_Internal__Convert_Attrs__(Path, fileName, lfs.attributes(Path .. "/" .. fileName))
      local IFile = Instance.new()
      IFile.Name = fileName
      IFile.Attributes = Attributes
      IFile.Parent = Folder
    end
  end

  return FileSystemService
end

return FileSystemModule
