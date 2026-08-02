/*
 * Mengine - Lightweight Lua game engine
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

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

extern lua_State *mengine_state;

extern void mengine_init();
extern const char *mengine_run(const char *pathname);
extern void mengine_free();

#ifdef MENGINE_IMPLEMENTATION
#include <stdbool.h>
#include <stdint.h>

#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>

lua_State *mengine_state;
bool inited = false;

typedef enum {
  MENGINE_BACKEND_SDL
} mengine_backend_t;

typedef struct {
  SDL_Window *window;
  SDL_Renderer *renderer;
  SDL_Event event;
  SDL_Texture *texture;
  TTF_Font *font;

  uint32_t frame_start;
  int target_fps;
  int delta_time;
  bool key_down[SDL_NUM_SCANCODES];
  bool key_held[SDL_NUM_SCANCODES];
  bool key_up[SDL_NUM_SCANCODES];

  SDL_Color color;
} mengine_window;

typedef struct {
  mengine_window *window;
  mengine_backend_t backend;
} mengine_input;

// ctx:color(r, g, b, a?);
static int l_gfx2d_color(lua_State *L) {
  lua_getfield(L, 1, "_win");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int r = luaL_checknumber(L, 2);
  int g = luaL_checknumber(L, 3);
  int b = luaL_checknumber(L, 4);
  int a = luaL_optnumber(L, 5, 255);
  win->color = (SDL_Color){r, g, b, a};
  return 0;
}

// ctx:text(text, x, y);
static int l_gfx2d_text(lua_State *L) {
  lua_getfield(L, 1, "_win");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  const char *text = luaL_checkstring(L, 2);
  int x = luaL_checknumber(L, 3);
  int y = luaL_checknumber(L, 4);

  SDL_Surface *surface = TTF_RenderUTF8_Blended(win->font, text, win->color);
  if (!surface) {
    return luaL_error(L, "TTF_RenderUTF8_Blended: %s", TTF_GetError());
  }

  SDL_Texture *texture = SDL_CreateTextureFromSurface(win->renderer, surface);
  if (!texture) {
    SDL_FreeSurface(surface);
    return luaL_error(L, "SDL_CreateTextureFromSurface: %s", SDL_GetError());
  }

  SDL_Rect dst = {x, y, surface->w, surface->h};
  SDL_RenderCopy(win->renderer, texture, NULL, &dst);
  SDL_DestroyTexture(texture);
  SDL_FreeSurface(surface);
  return 0;
}

// ctx:clear();
static int l_gfx2d_clear(lua_State *L) {
  lua_getfield(L, 1, "_win");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  SDL_SetRenderDrawColor(win->renderer, win->color.r, win->color.g, win->color.b, win->color.a);
  SDL_RenderClear(win->renderer);
  return 0;
}

// ctx:target_fps(target_fps?) 
static int l_gfx2d_target_fps(lua_State *L) {
  lua_getfield(L, 1, "_win");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);
  int target_fps = luaL_checknumber(L, 2);
  win->target_fps = target_fps;
  lua_pushnumber(L, win->target_fps);
  return 1;
}

// ctx:delta_time()
static int l_gfx2d_delta_time(lua_State *L) {
  lua_getfield(L, 1, "_win");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);
  lua_pushnumber(L, (float)(win->delta_time)/1000);
  return 1;
}

// ctx:end_frame() 
static int l_gfx2d_end_frame(lua_State *L) {
  lua_getfield(L, 1, "_win");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_RenderPresent(win->renderer);

  memset(win->key_down, 0, sizeof(win->key_down));
  memset(win->key_up, 0, sizeof(win->key_up));
  while (SDL_PollEvent(&win->event)) {
    if (win->event.type == SDL_QUIT) {
      lua_pushboolean(L, true);
      return 1;
    } else if (win->event.type == SDL_KEYDOWN) {
      if (win->event.key.repeat) continue;
      win->key_held[win->event.key.keysym.scancode] = true;
      win->key_down[win->event.key.keysym.scancode] = true;
    } else if (win->event.type == SDL_KEYUP) {
      win->key_held[win->event.key.keysym.scancode] = false;
      win->key_up[win->event.key.keysym.scancode] = true;
    }
  }
  
  uint32_t now = SDL_GetTicks();
  uint32_t frame_time = now - win->frame_start;
  uint32_t target_time = 1000 / win->target_fps;
  if (frame_time < target_time) {
    SDL_Delay(target_time - frame_time);
  }
  win->frame_start = SDL_GetTicks();
  win->delta_time = frame_time;

  lua_pushboolean(L, false);
  return 1;
}

// local ctx = win:getcontext()
static int l_gfx2d_getcontext(lua_State *L) {
  lua_getfield(L, 1, "_handle");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  lua_newtable(L);
  lua_pushlightuserdata(L, win);
  lua_setfield(L, -2, "_win");
  lua_pushcfunction(L, l_gfx2d_clear);
  lua_setfield(L, -2, "clear");
  lua_pushcfunction(L, l_gfx2d_target_fps);
  lua_setfield(L, -2, "target_fps");
  lua_pushcfunction(L, l_gfx2d_delta_time);
  lua_setfield(L, -2, "delta_time");
  lua_pushcfunction(L, l_gfx2d_end_frame);
  lua_setfield(L, -2, "end_frame");

  lua_pushcfunction(L, l_gfx2d_color);
  lua_setfield(L, -2, "color");
  lua_pushcfunction(L, l_gfx2d_text);
  lua_setfield(L, -2, "text");
  return 1;
}

// win:quit()
static int l_win_quit(lua_State *L) {
  lua_getfield(L, 1, "_handle");
  mengine_window *win = lua_touserdata(L, -1);
  if (win->texture) SDL_DestroyTexture(win->texture);
  if (win->renderer) SDL_DestroyRenderer(win->renderer);
  if (win->window) SDL_DestroyWindow(win->window);
  if (win->font) TTF_CloseFont(win->font);
  lua_pop(L, 1);
  return 0;
}

// local win = gfx:init("meow", 800, 600, target_fps?);
static int l_gfx2d_init(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);
  int width = luaL_checkinteger(L, 3);
  int height = luaL_checkinteger(L, 4);
  int target_fps = luaL_optinteger(L, 5, 60);

  if (!inited) {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
      return luaL_error(L, "SDL_Init: %s", SDL_GetError());
    }

    if (TTF_Init() == -1) {
      return luaL_error(L, "TTF_Init: %s", TTF_GetError());
    }

    inited = true;
  }

  lua_newtable(L);

  lua_pushcfunction(L, l_gfx2d_getcontext);
  lua_setfield(L, -2, "getcontext");
  lua_pushcfunction(L, l_win_quit);
  lua_setfield(L, -2, "quit");
  lua_pushinteger(L, width);
  lua_setfield(L, -2, "width");
  lua_pushinteger(L, height);
  lua_setfield(L, -2, "height");

  mengine_window *win = lua_newuserdata(L, sizeof(*win));
  win->window = SDL_CreateWindow(
    name,
    SDL_WINDOWPOS_CENTERED,
    SDL_WINDOWPOS_CENTERED,
    width,
    height,
    SDL_WINDOW_SHOWN
  );
  if (!win->window) {
    return luaL_error(L, "SDL_CreateWindow: %s", SDL_GetError());
  }

  win->renderer = SDL_CreateRenderer(win->window, -1,
    SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
  if (!win->renderer) {
    return luaL_error(L, "SDL_CreateRenderer: %s", SDL_GetError());
  }

  win->texture = NULL;

  win->font = TTF_OpenFont("/usr/share/fonts/TTF/DejaVuSans.ttf", 24);
  if (!win->font) {
    return luaL_error(L, "TTF_OpenFont: %s", TTF_GetError());
  }
  
  win->target_fps = target_fps;
  win->frame_start = SDL_GetTicks();
  win->delta_time = 1000/target_fps;
  win->color = (SDL_Color){0, 0, 0, 255};

  memset(win->key_held, 0, sizeof(win->key_held));
  memset(win->key_down, 0, sizeof(win->key_down));
  memset(win->key_up, 0, sizeof(win->key_up));

  luaL_getmetatable(L, "mengine.window");
  lua_setmetatable(L, -2);
  lua_setfield(L, -2, "_handle");
  return 1;
}

static mengine_input *input_check(lua_State *L) {
  lua_getfield(L, 1, "_handle");
  mengine_input *input = lua_touserdata(L, -1);
  lua_pop(L, 1);
  if (!input) luaL_error(L, "input is not initialized");
  return input;
}

static int input_key_state(lua_State *L, bool *state) {
  input_check(L);
  const char *key = luaL_checkstring(L, 2);
  SDL_Scancode sc = SDL_GetScancodeFromName(key);
  lua_pushboolean(L, state[sc]);
  return 1;
}

static int input_keys(lua_State *L, bool *state) {
  luaL_Buffer b;
  luaL_buffinit(L, &b);
  bool first = true;
  for (int i = 0; i < SDL_NUM_SCANCODES; i++) {
    if (!state[i]) {
      continue;
    }
    if (!first) {
      luaL_addchar(&b, ' ');
    }
    luaL_addstring(&b, SDL_GetScancodeName((SDL_Scancode)i));
    first = false;
  }
  luaL_pushresult(&b);
  return 1;
}

// input:key_held(key);
static int l_input_key_held(lua_State *L) {
  return input_key_state(L, input_check(L)->window->key_held);
}

// input:key_down(key);
static int l_input_key_down(lua_State *L) {
  return input_key_state(L, input_check(L)->window->key_down);
}

// input:key_up(key);
static int l_input_key_up(lua_State *L) {
  return input_key_state(L, input_check(L)->window->key_up);
}

// input:held();
static int l_input_held(lua_State *L) {
  return input_keys(L, input_check(L)->window->key_held);
}

// input:down();
static int l_input_down(lua_State *L) {
  return input_keys(L, input_check(L)->window->key_down);
}

// input:up();
static int l_input_up(lua_State *L) {
  return input_keys(L, input_check(L)->window->key_up);
}

static int l_input_init(lua_State *L) {
  const char *backend = luaL_checkstring(L, 2);
  if (strcmp(backend, "sdl") != 0) {
    return luaL_error(L, "unknown backend: %s", backend);
  }

  lua_getfield(L, 3, "_handle");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  mengine_input *input = lua_newuserdata(L, sizeof(*input));
  input->window = win;
  input->backend = MENGINE_BACKEND_SDL;
  luaL_getmetatable(L, "mengine.input");
  lua_setmetatable(L, -2);
  lua_setfield(L, 1, "_handle");
  return 0;
}

void service_gfx2d(lua_State *L) {
  lua_newtable(L);
  
  lua_pushcfunction(L, l_gfx2d_init);
  lua_setfield(L, -2, "init");
}

void service_input(lua_State *L) {
  lua_newtable(L);
  lua_pushcfunction(L, l_input_init);
  lua_setfield(L, -2, "init");

  lua_pushcfunction(L, l_input_key_held);
  lua_setfield(L, -2, "key_held");
  lua_pushcfunction(L, l_input_held);
  lua_setfield(L, -2, "held");
  
  lua_pushcfunction(L, l_input_key_down);
  lua_setfield(L, -2, "key_down");
  lua_pushcfunction(L, l_input_down);
  lua_setfield(L, -2, "down");
  
  lua_pushcfunction(L, l_input_key_up);
  lua_setfield(L, -2, "key_up");
  lua_pushcfunction(L, l_input_up);
  lua_setfield(L, -2, "up");
}

// local gfx = mengine:getservice(service_name);
int l_getservice(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);

  if (strcmp(name, "gfx:2d") == 0) {
    service_gfx2d(L);
  } else if (strcmp(name, "input") == 0) {
    service_input(L);
  } else {
    return luaL_error(L, "unknown service: '%s'", name);
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
  TTF_Quit();
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
