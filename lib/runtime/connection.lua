local Connection = {}

function Connection.new(Callback, DisconnectCallback)
  local self = {}

  self.Connected = Callback and true or false
  self.Callback = Callback
  self.DisconnectCallback = DisconnectCallback

  function self:Disconnect()
    if not self.Connected then return end
    
    self.Connected = false
    if self.DisconnectCallback then
      self.DisconnectCallback()
    end
  end
end

return Connection
