#define LUNAR_VERSION "0.3.5"
/*
 * CHANGELOG:
 * v0.3.5:
 *  Added:
 *   More Services (HttpServerService, HttpSharedService, RandomService)
 *   More functions and signals to Instance
 *   More functions to RunService (
 *    .IsClient,
 *    .IsServer,
 *    :SetServerMode()
 *    :SetClientMode()
 *    .IsSeverBool
 *   )
 * v0.3.0:
 *  Improvement update
 *  Improved:
 *   FileSystemService (
 *    Fixed FSS:GetFolder()
 *    Add instances/classnames for files and folders
 *    Add more functions to FSS
 *   )
 *   ConsoleService (
 *    Add more functions to ConsoleService
 *   )
 *   Changed ErrorService.OnError to ErrorService.ErrorHandler
 *   Make JSONService use json.lua from https://github.com/rxi/json.lua because
 * it has better handling and more safer Fully implement CFrame Instance ( Add
 * more functions and events (Destroying, ChildAdded and ChildRemoved) to
 * Instance Add Tags and Attributes
 *   )
 *   init.lua (
 *    Add base variable
 *   )
 *  Added:
 *   String Library (LStringLibrary)
 *   Alias for load -> loadstring function
 *   Alias for LMathLibrary, LTableLibrary, LStringLibrary -> lmath, ltable,
 * lstring (globals) v0.2.5: Added: More Services (LMathService, LTableService,
 * JSONService, HttpClientService) More datatypes (CFrame, Color4, UDim, UDim2)
 *   Make instance better (
 *     Clone children in Instance:Clone()
 *     Add Instance:GetChildrenCount()
 *     Add Instance:GetDescendants()
 *     Add Instance:IsA(ClassName)
 *     Add Instance:GetFullName(ClassName)
 *   )
 * v0.2.0:
 *  Added:
 *   ClassNames
 *   Instance:Destroy/Clone()
 *   Fix Instances
 *   More Services (TimeService, ErrorService, TaskService, RunService)
 *   More datatypes (Vector2, Vector3, Color3)
 *   Change TaskService:Wait/Delay to TaskService.wait/delay
 *   Added DeltaTime to RunService
 * v0.1.1:
 *  Added:
 *   Service Manager
 *   ConsoleService and FileSystemService
 * v0.1.0:
 *  Added:
 *   Instance
 *   Signal
 *   Connection
 *   init.lua
 */

#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>

typedef struct {
  char *name;
  int Service;
} LunarService;

typedef int (*Lunar_registry_fire)(lua_State *L, ...);

extern lua_State *LunarState;

extern void LunarInit();
extern const char *LunarRun(const char *FilePath);
extern void LunarQuit();
extern void LunarRegisterService(LunarService Service);
extern void LunarRemoveService(const char *ServiceName);
extern LunarService LunarSearchService(const char *ServiceName);

#ifdef LUNAR_IMPLEMENTATION
#include <stdbool.h>
#include <stdint.h>

lua_State *LunarState;

LunarService LunarServices[256];
int LunarServiceCount = 0;

Lunar_registry_fire lunar_registry_functions[256];
int Lunar_registry_function_count = 0;

int LuaInstance_new(lua_State *L) {
  lua_newtable(L);
  return 1;
}

int LuaInstance(lua_State *L) {
  lua_newtable(L);
  lua_pushcfunction(L, LuaInstance_new);
  lua_setfield(L, -2, "new");
  return 1;
}

void LunarRegisterService(LunarService service) {
  LunarServices[LunarServiceCount++] = service;
}

void LunarRemoveService(const char *service_name) {
  for (int i = 0; i < LunarServiceCount; i++) {
    if (strcmp(LunarServices[i].name, service_name) == 0) {
      for (int j = i; j < LunarServiceCount - 1; j++) {
        LunarServices[j] = LunarServices[j + 1];
      }
      LunarServiceCount--;
      return;
    }
  }
}

int LuaSereviceManagerGetServices(lua_State *L) {
  lua_newtable(LunarState);
  for (int i = 0; i < LunarServiceCount; i++) {
    lua_rawgeti(L, LUA_REGISTRYINDEX, LunarServices[i].Service);
    lua_setfield(LunarState, -2, LunarServices[i].name);
  }
  return 1;
}

int LuaSereviceManagerRegisterService(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);
  luaL_checktype(L, 3, LUA_TTABLE);
  int ref = luaL_ref(L, LUA_REGISTRYINDEX);

  LunarRegisterService((LunarService){strdup(name), ref});
  return 0;
}

int LuaSereviceManagerRemoveService(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);
  LunarRemoveService(name);
  return 0;
}

int LuaSereviceManager(lua_State *L) {
  lua_newtable(L);

  lua_pushcfunction(L, LuaSereviceManagerGetServices);
  lua_setfield(L, -2, "GetServices");

  lua_pushcfunction(L, LuaSereviceManagerRegisterService);
  lua_setfield(L, -2, "RegisterService");

  lua_pushcfunction(L, LuaSereviceManagerRemoveService);
  lua_setfield(L, -2, "RemoveService");
  return 1;
}

void LunarInit() {
  LunarState = luaL_newstate();
  luaL_openlibs(LunarState);

  lua_getglobal(LunarState, "load");
  lua_setglobal(LunarState, "loadstring");

  lua_newtable(LunarState);

  LuaInstance(LunarState);
  lua_setglobal(LunarState, "__Lunar_C__Instance__");

  LuaSereviceManager(LunarState);
  lua_setglobal(LunarState, "__Lunar_C__ServiceManager__");

  const char *Home = getenv("HOME");
  char runtime_path[4096];
  snprintf(runtime_path, sizeof(runtime_path),
           "%s/.local/share/lunare/lib/runtime/init.lua", Home);

  if (luaL_dofile(LunarState, runtime_path) != LUA_OK) {
    fprintf(stderr, "[Lunar] runtime error: %s\n",
            lua_tostring(LunarState, -1));
    lua_pop(LunarState, 1);
    return;
  }

  lua_getfield(LunarState, -1, "Instance");
  lua_setglobal(LunarState, "Instance");

  lua_getfield(LunarState, -1, "Connection");
  lua_setglobal(LunarState, "Connection");

  lua_getfield(LunarState, -1, "Signal");
  lua_setglobal(LunarState, "Signal");

  lua_getfield(LunarState, -1, "Vector2");
  lua_setglobal(LunarState, "Vector2");

  lua_getfield(LunarState, -1, "Vector3");
  lua_setglobal(LunarState, "Vector3");

  lua_getfield(LunarState, -1, "Color3");
  lua_setglobal(LunarState, "Color3");

  lua_getfield(LunarState, -1, "Color4");
  lua_setglobal(LunarState, "Color4");

  lua_getfield(LunarState, -1, "CFrame");
  lua_setglobal(LunarState, "CFrame");

  lua_getfield(LunarState, -1, "UDim");
  lua_setglobal(LunarState, "UDim");

  lua_getfield(LunarState, -1, "UDim2");
  lua_setglobal(LunarState, "UDim2");

  lua_getfield(LunarState, -1, "LMathLibrary");
  lua_setglobal(LunarState, "lmath");

  lua_getfield(LunarState, -1, "LTableLibrary");
  lua_setglobal(LunarState, "ltable");

  lua_getfield(LunarState, -1, "LStringLibrary");
  lua_setglobal(LunarState, "lstring");

  lua_getfield(LunarState, -1, "RandomModule");
  lua_setglobal(LunarState, "Random");

  lua_newtable(LunarState);

  lua_getfield(LunarState, -2, "ServiceManager");
  lua_getfield(LunarState, -1, "GetService");
  lua_setfield(LunarState, -3, "GetService");
  lua_pop(LunarState, 1);

  lua_pushstring(LunarState, "Lunar v" LUNAR_VERSION);
  lua_setfield(LunarState, -2, "Version");

#if __ANDROID__
  lua_pushstring(LunarState, "Android");
#elif __linux__
  lua_pushstring(LunarState, "Linux");
#elif _WIN32
  lua_pushstring(LunarState, "Windows");
#elif __APPLE__
  lua_pushstring(LunarState, "Apple");
#elif __EMSCRIPTEN__
  lua_pushstring(LunarState, "Web");
#endif

  lua_setfield(LunarState, -2, "Platform");

  lua_setglobal(LunarState, "Lunar");
}

void LunarQuit() { lua_close(LunarState); }

const char *LunarRun(const char *FilePath) {
  int Status = luaL_loadfile(LunarState, FilePath);
  if (Status == LUA_OK) {
    Status = lua_pcall(LunarState, 0, LUA_MULTRET, 0);
  }
  if (Status != LUA_OK) {
    const char *ErrorMessage = lua_tostring(LunarState, -1);
    lua_pop(LunarState, 1);
    return ErrorMessage;
  }
  return NULL;
}
#endif
