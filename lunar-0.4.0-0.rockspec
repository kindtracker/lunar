package = "lunar"
version = "0.4.0-0"

source = {
  url = "git+https://github.com/kindtracker/lunar.git",
}

description = {
  summary = "a general-purpose Lua engine",
  detailed = "Lunar is a general-purpose Lua engine with Roblox-like instances and more. It can be used for servers, games, web applications, and more.",
  homepage = "https://github.com/kindtracker/lunar",
  license = "GPL-3.0-or-later",
}

dependencies = {
  "lua >= 5.5",
}

build = {
  type = "builtin",
  modules = {
    ["lunar"] = "package/init.lua",

    ["lunar.src.init"] = "package/src/init.lua",

    ["lunar.src.core.instance"] = "package/src/core/instance.lua",
    ["lunar.src.core.service"] = "package/src/core/service.lua",

    ["lunar.src.datatypes.cframe"] = "package/src/datatypes/cframe.lua",
    ["lunar.src.datatypes.color3"] = "package/src/datatypes/color3.lua",
    ["lunar.src.datatypes.color4"] = "package/src/datatypes/color4.lua",
    ["lunar.src.datatypes.connection"] = "package/src/datatypes/connection.lua",
    ["lunar.src.datatypes.signal"] = "package/src/datatypes/signal.lua",
    ["lunar.src.datatypes.udim"] = "package/src/datatypes/udim.lua",
    ["lunar.src.datatypes.udim2"] = "package/src/datatypes/udim2.lua",
    ["lunar.src.datatypes.vector2"] = "package/src/datatypes/vector2.lua",
    ["lunar.src.datatypes.vector3"] = "package/src/datatypes/vector3.lua",

    ["lunar.src.services.console"] = "package/src/services/console.lua",
    ["lunar.src.services.error"] = "package/src/services/error.lua",
    ["lunar.src.services.fs"] = "package/src/services/fs.lua",
    ["lunar.src.services.http-client"] = "package/src/services/http-client.lua",
    ["lunar.src.services.http-server"] = "package/src/services/http-server.lua",
    ["lunar.src.services.http-shared"] = "package/src/services/http-shared.lua",
    ["lunar.src.services.json"] = "package/src/services/json.lua",
    ["lunar.src.services.plugin"] = "package/src/services/plugin.lua",
    ["lunar.src.services.random"] = "package/src/services/random.lua",
    ["lunar.src.services.run"] = "package/src/services/run.lua",
    ["lunar.src.services.task"] = "package/src/services/task.lua",
    ["lunar.src.services.time"] = "package/src/services/time.lua",

    ["lunar.src.services.libraries.lmath"] = "package/src/services/libraries/lmath.lua",
    ["lunar.src.services.libraries.lstring"] = "package/src/services/libraries/lstring.lua",
    ["lunar.src.services.libraries.ltable"] = "package/src/services/libraries/ltable.lua",

    ["json"] = "package/vendors/json.lua",
    ["url"] = "package/vendors/url.lua",

    ["pegasus"] = "package/vendors/pegasus/init.lua",
    ["pegasus.compress"] = "package/vendors/pegasus/compress.lua",
    ["pegasus.handler"] = "package/vendors/pegasus/handler.lua",
    ["pegasus.log"] = "package/vendors/pegasus/log.lua",
    ["pegasus.request"] = "package/vendors/pegasus/request.lua",
    ["pegasus.response"] = "package/vendors/pegasus/response.lua",

    ["pegasus.plugins.compress"] = "package/vendors/pegasus/plugins/compress.lua",
    ["pegasus.plugins.downloads"] = "package/vendors/pegasus/plugins/downloads.lua",
    ["pegasus.plugins.files"] = "package/vendors/pegasus/plugins/files.lua",
    ["pegasus.plugins.router"] = "package/vendors/pegasus/plugins/router.lua",
    ["pegasus.plugins.tls"] = "package/vendors/pegasus/plugins/tls.lua",
  },
}
