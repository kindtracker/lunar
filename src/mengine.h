#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

extern lua_State *mengine_state;

extern void mengine_init();
extern const char *mengine_run(const char *pathname);
extern void mengine_free();

#ifdef MENGINE_IMPLEMENTATION
#include <SDL2/SDL.h>

lua_State *mengine_state;

// gfx:init("meow", 800, 600);
int l_gfx2d_init(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);
  int width = luaL_checknumber(L, 3);
  int height = luaL_checknumber(L, 4);
  printf("%s %d %d\n", name, width, height);
  return 0;
}

// gfx:text("meow", 0, 0);
int l_gfx2d_text(lua_State *L) {
  return 0;
}

void service_gfx2d(lua_State *L) {
  lua_newtable(L);
  
  lua_pushcfunction(L, l_gfx2d_init);
  lua_setfield(L, -2, "init");
  lua_pushcfunction(L, l_gfx2d_text);
  lua_setfield(L, -2, "text");
}

// local gfx = mengine:getservice("gfx:2d");
int l_getservice(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);
  printf("name: %s\n", name);

  if (strcmp(name, "gfx:2d") == 0) {
    service_gfx2d(L);
  } else {
    return luaL_error(L, "unknown service '%s'", name);
  }

  return 1;
}

void mengine_init() {
  mengine_state = luaL_newstate();
  luaL_openlibs(mengine_state);

  lua_newtable(mengine_state);

  lua_pushcfunction(mengine_state, l_getservice);
  lua_setfield(mengine_state, -2, "getservice");
  
  lua_setglobal(mengine_state, "mengine");
}

void mengine_quit() {
  lua_close(mengine_state);
  SDL_Quit();
}

const char *mengine_run(const char *pathname) {
  int status = luaL_loadfile(mengine_state, pathname);
  if (status == LUA_OK) {
    status = lua_pcall(mengine_state, 0, LUA_MULTRET, 0);
  }
  if (status != LUA_OK) {
    const char *err_msg = lua_tostring(mengine_state, -1);
    lua_pop(mengine_state, 1);
    return err_msg;
  }
  return NULL;
}
#endif
