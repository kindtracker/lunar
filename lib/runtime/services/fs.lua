local lfs = require("lfs")

local FileSystemModule = {}
local FileSystemService
local Instance

FileSystemModule.FileInstanceModule = {}
FileSystemModule.FolderInstanceModule = {}
function FileSystemModule.FileInstanceModule.new()
  return {
    Attributes = {},
    FilePtr = nil,
    Mode = "",
  }
end

function FileSystemModule.FolderInstanceModule.new()
  return {}
end

function FileSystemModule.__Lunar_Internal__Init__(instance)
  Instance = instance

  FileSystemService = Instance.new("Service")
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
    Recursive = Recursive or false

    local Folder = Instance.new("Folder")
    Folder.Name = Name

    for FileName in lfs.dir(Path) do
      local FilePath = Path .. "/" .. FileName

      if FileName ~= "." and FileName ~= ".." then
        local Attributes =
          FileSystemService:__Lunar_Internal__Convert_Attrs__(FilePath, FileName, lfs.attributes(FilePath))

        local File = Instance.new()
        File.Name = FileName
        File.Attributes = Attributes
        File.Parent = Folder

        if Recursive and Attributes.Type == "Folder" then
          local ChildFolder = FileSystemService:GetFolder(FilePath, FileName, true)
          ChildFolder.Parent = File
        end
      end
    end

    return Folder
  end

  function FileSystemService:Open(Path, Name, Mode)
    local File = Instance.new("File")
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
      if Offset then
        File:Seek("set", Offset)
      end
      return File.FilePtr:read(readMode)
    end

    function File:Write(Format, ...)
      File.FilePtr:write(string.format(Format, ...))
    end

    return File
  end

  function FileSystemService:CreateFolder(Path)
    return lfs.mkdir(Path)
  end

  function FileSystemService:Delete(Path)
    return os.remove(Path)
  end

  function FileSystemService:Move(FromPath, ToPath)
    return os.rename(FromPath, ToPath)
  end

  function FileSystemService:Copy(FromPath, ToPath)
    local FromFile = FileSystemService:Open(FromPath, FromPath, "rb")
    local FromContent = FromFile:Read("*a")
    local ToFile = FileSystemService:Open(ToPath, ToPath, "wb")
    if FromFile == nil or ToFile == nil then
      return nil
    end
    ToFile:Write(FromContent)
    FromFile:Close()
    ToFile:Close()
    FromFile:Destroy()
    ToFile:Destroy()
  end

  return FileSystemService
end

return FileSystemModule, FileSystemModule.FileInstanceModule, FileSystemModule.FolderInstanceModule
