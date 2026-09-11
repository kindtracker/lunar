local lfs = require("lfs")

local FileSystemModule = {}
local FileSystemService
local Instance

function FileSystemModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  FileSystemService = Instance.new("FileSystemService")
  FileSystemService.Name = "FileSystemService"

  function FileSystemService:__Lunar_Internal__Convert_Attrs__(Path, Name, Attributes)
    local ModeList = {
      ["directory"] = "Folder",
      ["file"] = "File",
      ["socket"] = "Socket",
      ["named pipe"] = "NamedPipe",
      ["char device"] = "CharDevice",
      ["block device"] = "BlockDevice",
      ["other"] = "Unknown",
    }
    local Lunar_Attributes = {
      Name = Name,
      Path = Path,
      Type = ModeList[Attributes.mode],
      Size = Attributes.size,
      ModificationTime = Attributes.modification,
      AccessTime = Attributes.access,
      ChangeTime = Attributes.change,
      Permissions = Attributes.permissions,
    }

    for key, value in pairs(Attributes) do
      Lunar_Attributes["__Hidden_LFS__" .. key] = value
    end

    return Lunar_Attributes
  end

  function FileSystemService:GetFolder(Path, Name, Recursive)
    Recursive = Recursive and Recursive or false

    local Folder = Instance.new()
    Folder.Name = Name
    local Files = lfs.dir(Path)
    for fileName in Files do
      local Attributes =
        FileSystemService:__Lunar_Internal__Convert_Attrs__(Path, fileName, lfs.attributes(Path .. "/" .. fileName))
      local File = Instance.new()
      File.Name = fileName
      File.Attributes = Attributes
      File.Parent = Folder

      if Recursive then
        if File.Attributes.Type == "Folder" then
          FileSystemService:GetFolder(Path, fileName, Recursive - 1)
        end
      end
    end
  end

  function FileSystemService:Open(Path, Name, Mode)
    local File = Instance.new()
    File.Name = Name
    File.FilePtr = io.open(Path, Mode)
    if not File.FilePtr then
      return nil
    end
    File.Attributes = FileSystemService:__Lunar_Internal__Convert_Attrs__(Path, Name, lfs.attributes(Path))
    File.Mode = Mode

    function File:Seek(Whence, Offset)
      Whence = Whence and Whence or "set"
      Offset = Offset and Offset or 0
      File.FilePtr:seek(Whence, Offset)
    end

    function File:Close()
      File.FilePtr:close()
    end

    function File:Read(readMode, Offset)
      File:Seek("set", Offset)
      return File.FilePtr:read(readMode)
    end

    function File:Write(Format, ...)
      File.FilePtr:write(string.format(Format, ...))
    end

    return File
  end

  return FileSystemService
end

return FileSystemModule
