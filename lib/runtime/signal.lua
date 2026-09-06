local Signal = {}

function Signal.new()
  local self = {}

  self.Connections = {}

  function self:Connect(Callback, DisconnectCallback)
    local connection = Connection.new(callback, function()
      for i, registeredConnection in ipairs(self.Connections) do
        if registeredConnection == connection then
          table.remove(self.Connections, i)
          break
        end
      end
      if DisconnectCallback then
        DisconnectCallback(connection)
      end
    end)

    table.insert(self.Connections, connection)
    return connection
  end

  function self:DisconnectAll()
    for _, connection in ipairs(self.Connections) do
      connection:Disconnect()
    end
    table.clear(self.Connections)
  end

  function self:Fire(...)
    for _, connection in ipairs(self.Connections) do
      if connection.Connected then
        connection.Callback(...)
      end
    end
  end

  return self
end

return Signal
