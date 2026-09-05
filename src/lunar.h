/*
 * Lunar - Lightweight Lua engine
 *
 * Copyright (C) 2026 kindtracker
 *
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#define LUNAR_VERSION "0.0.1"
/*
 * CHANGELOG:
 * v0.0.1
 */

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

typedef struct {
  char *name;
  int (*service)(lua_State *L);
} lunar_service;

extern lua_State *lunar_state;

extern void lunar_init();
extern const char *lunar_run(const char *pathname);
extern void lunar_free();
extern void lunar_add_service(lunar_service service);
extern void lunar_remove_service(const char *service_name);
extern lunar_service lunar_search_service(const char *service_name);

#ifdef LUNAR_IMPLEMENTATION
#include <stdbool.h>
#include <stdint.h>

lua_State *lunar_state;

lunar_service lunar_services[256];
int lunar_service_count = 0;

/*
static const char *lunar_log_get(lua_State *L) {
  lua_getglobal(L, "string");
  lua_getfield(L, -1, "format");
  lua_remove(L, -2);
  lua_insert(L, 1);
  lua_call(L, lua_gettop(L) - 1, 1);
  return lua_tostring(L, -1);
}

// lunar.log(format, ...)
static int l_log(lua_State *L) {
  printf("\033[32m[log]\033[0m %s\n", lunar_log_get(L));
  return 0;
}

// lunar.info(format, ...)
static int l_info(lua_State *L) {
  printf("\033[36m[info]\033[0m %s\n", lunar_log_get(L));
  return 0;
}

// lunar.warn(format, ...)
static int l_warn(lua_State *L) {
  printf("\033[33m[warning]\033[0m %s\n", lunar_log_get(L));
  return 0;
}

// lunar.error(format, ...)
static int l_error(lua_State *L) {
  printf("\033[31m[error]\033[0m %s\n", lunar_log_get(L));
  return 0;
}

// lunar.fatal(format, ...)
static int l_fatal(lua_State *L) {
  printf("\033[31m[fatal]\033[0m %s\n", lunar_log_get(L));
  return 0;
}

// lunar.wait(sec)
static int l_wait(lua_State *L) {
  float sec = luaL_checknumber(L, 2);
  SDL_Delay(sec*1000);
  return 0;
}

// lunar.time(sec)
static int l_time(lua_State *L) {
  lua_pushnumber(L, (float)(SDL_GetTicks())/1000);
  return 1;
}
*/

void lunar_add_service(lunar_service service) {
  lunar_services[lunar_service_count++] = service;
}

void lunar_remove_service(const char *service_name) {
  for (int i = 0; i < lunar_service_count; i++) {
    if (strcmp(lunar_services[i].name, service_name) == 0) {
      for (int j = i; j < lunar_service_count - 1; j++) {
        lunar_services[j] = lunar_services[j + 1];
      }
      lunar_service_count--;
      return;
    }
  }
}

lunar_service lunar_search_service(const char *service_name) {
  for (int i = 0; i < lunar_service_count; i++) {
    lunar_service service = lunar_services[i];
    if (service.name && (strcmp(service.name, service_name) == 0)) {
      return service;
    }
  }
  return (lunar_service){.name = NULL, .service = NULL};
}

static int l_getservice(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);
  lunar_service service = lunar_search_service(name);
  return service.service(L);
}

int l_instance(lua_State *L);
int l_instance_new(lua_State *L) {
  return l_instance(L);
}

int l_instance_destroy(lua_State *L) {
  luaL_checktype(L, 1, LUA_TTABLE);
  lua_pushnil(L);
  while (lua_next(L, 1) != 0) {
    lua_pop(L, 1);
    lua_pushvalue(L, -1);
    lua_pushnil(L);
    lua_settable(L, 1);
  }

  return 0;
}

int l_instance(lua_State *L) {
  lua_newtable(L);

  lua_pushcfunction(L, l_instance_new);
  lua_setfield(L, -2, "new");
  lua_pushcfunction(L, l_instance_destroy);
  lua_setfield(L, -2, "destroy");
  return 1;
}

void lunar_init() {
  lunar_state = luaL_newstate();
  luaL_openlibs(lunar_state);

  lua_newtable(lunar_state);

  lua_pushcfunction(lunar_state, l_getservice);
  lua_setfield(lunar_state, -2, "GetService");

  lua_pushstring(lunar_state, "Lunar v"LUNAR_VERSION);
  lua_setfield(lunar_state, -2, "Version");

  lua_setglobal(lunar_state, "Lunar");
  
  l_instance(lunar_state);
  lua_setglobal(lunar_state, "Instance");
}

void lunar_quit() {
  lua_close(lunar_state);
}

const char *lunar_run(const char *pathname) {
  int status = luaL_loadfile(lunar_state, pathname);
  if (status == LUA_OK) {
    status = lua_pcall(lunar_state, 0, LUA_MULTRET, 0);
  }
  if (status != LUA_OK) {
    const char *err_msg = lua_tostring(lunar_state, -1);
    lua_pop(lunar_state, 1);
    return err_msg;
  }
  return NULL;
}
#endif
