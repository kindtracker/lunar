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

extern lua_State *LunarState;

void LunarInit();
const char *LunarRun(const char *FilePath);
void LunarQuit();
void LunarRegisterService(LunarService Service);
void LunarRemoveService(const char *ServiceName);
LunarService LunarSearchService(const char *ServiceName);
