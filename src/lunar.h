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

#define LUNAR_VERSION "0.2.0"
/*
 * CHANGELOG:
 * 0.2.0:
 *   added: lunar.version
 *   added: lunar_add_service(lunar_service *service)
 *   added: lunar_remove_service(const char *service_name)
 *   added: lunar_search_service(const char *service_name)
 */

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

typedef enum {
  lunar_BACKEND_SDL
} lunar_backend_t;

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

#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>
#include <SDL2/SDL_image.h>

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
  int line_width;
} lunar_window;

typedef struct {
  lunar_window *window;
  lunar_backend_t backend;
} lunar_input;

typedef struct {
  SDL_Texture *texture;
  int width;
  int height;
} lunar_image;

lua_State *lunar_state;
bool lunar_inited = false;

lunar_service lunar_services[64];
int lunar_service_count = 0;

// ctx:color(r, g, b, a?);
static int l_gfx2d_color(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
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
  lunar_window *win = lua_touserdata(L, -1);
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

// ctx:image(image, x, y, w?, h?)
static int l_gfx2d_image(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  luaL_checktype(L, 2, LUA_TTABLE);

  lua_getfield(L, 2, "image");
  SDL_Texture *texture = lua_touserdata(L, -1);
  lua_pop(L, 1);

  lua_getfield(L, 2, "width");
  int width = lua_tointeger(L, -1);
  lua_pop(L, 1);

  lua_getfield(L, 2, "height");
  int height = lua_tointeger(L, -1);
  lua_pop(L, 1);

  int x = luaL_checkinteger(L, 3);
  int y = luaL_checkinteger(L, 4);
  int w = luaL_optinteger(L, 5, width);
  int h = luaL_optinteger(L, 6, height);

  SDL_Rect dst = {x, y, w, h};
  SDL_RenderCopy(win->renderer, texture, NULL, &dst);
  return 0;
}

// ctx:image_part(image, sx, sy, sw, sh, dx, dy, dw?, dh?)
static int l_gfx2d_image_part(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  luaL_checktype(L, 2, LUA_TTABLE);

  lua_getfield(L, 2, "image");
  SDL_Texture *texture = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int sx = luaL_checkinteger(L, 3);
  int sy = luaL_checkinteger(L, 4);
  int sw = luaL_checkinteger(L, 5);
  int sh = luaL_checkinteger(L, 6);
  int dx = luaL_checkinteger(L, 7);
  int dy = luaL_checkinteger(L, 8);
  int dw = luaL_optinteger(L, 9, sw);
  int dh = luaL_optinteger(L, 10, sh);

  SDL_Rect src = { sx, sy, sw, sh };
  SDL_Rect dst = { dx, dy, dw, dh };
  SDL_RenderCopy(win->renderer, texture, &src, &dst);
  return 0;
}

static int l_gfx2d_line_width(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int thick = luaL_checknumber(L, 2);
  win->line_width = thick;
  return 0;
}

// ctx:px(x, y);
static int l_gfx2d_pixel(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int x = luaL_checknumber(L, 2);
  int y = luaL_checknumber(L, 3);

  SDL_SetRenderDrawColor(win->renderer, win->color.r, win->color.g, win->color.b, win->color.a);
  SDL_RenderDrawPoint(win->renderer, x, y);
  return 0;
}

// ctx:line(x2, y2, x2, y2);
static int l_gfx2d_line(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int x1 = luaL_checknumber(L, 2);
  int y1 = luaL_checknumber(L, 3);
  int x2 = luaL_checknumber(L, 4);
  int y2 = luaL_checknumber(L, 5);

  SDL_SetRenderDrawColor(win->renderer, win->color.r, win->color.g, win->color.b, win->color.a);
  if (win->line_width == 1) {
    SDL_RenderDrawLine(win->renderer, x1, y1, x2, y2);
    return 0;
  }
  float dx = (float)(x2 - x1);
  float dy = (float)(y2 - y1);
  float len = sqrtf(dx * dx + dy * dy);
  if (len == 0.0f) {
    return 0;
  }
  float nx = -dy / len;
  float ny =  dx / len;
  float half = (win->line_width - 1) / 2.0f;
  for (float i = -half; i <= half; i += 1.0f) {
    SDL_RenderDrawLine(win->renderer, (int)roundf(x1 + nx * i), (int)roundf(y1 + ny * i), (int)roundf(x2 + nx * i), (int)roundf(y2 + ny * i));
  }
  return 0;
}

// NOTE: shape api is ai-generated (it is too long and repetitive), this api is not tested
// ctx:rect(x, y, w, h);
static int l_gfx2d_rect(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int x = luaL_checknumber(L, 2);
  int y = luaL_checknumber(L, 3);
  int w = luaL_checknumber(L, 4);
  int h = luaL_checknumber(L, 5);

  SDL_SetRenderDrawColor(win->renderer,
    win->color.r,
    win->color.g,
    win->color.b,
    win->color.a);

  for (int i = 0; i < win->line_width; i++) {
    SDL_Rect rect = {
      x + i,
      y + i,
      w - i * 2,
      h - i * 2
    };

    if (rect.w <= 0 || rect.h <= 0) {
      break;
    }

    SDL_RenderDrawRect(win->renderer, &rect);
  }

  return 0;
}

// ctx:rect_fill(x, y, w, h);
static int l_gfx2d_rect_fill(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int x = luaL_checknumber(L, 2);
  int y = luaL_checknumber(L, 3);
  int w = luaL_checknumber(L, 4);
  int h = luaL_checknumber(L, 5);

  SDL_SetRenderDrawColor(win->renderer, win->color.r, win->color.g, win->color.b, win->color.a);

  SDL_Rect rect = {x, y, w, h};
  SDL_RenderFillRect(win->renderer, &rect);
  return 0;
}

// ctx:circ(x, y, r);
static int l_gfx2d_circ(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int cx = luaL_checknumber(L, 2);
  int cy = luaL_checknumber(L, 3);
  int r = luaL_checknumber(L, 4);

  SDL_SetRenderDrawColor(win->renderer,
    win->color.r,
    win->color.g,
    win->color.b,
    win->color.a);

  for (int i = 0; i < win->line_width; i++) {
    int radius = r - i;

    if (radius <= 0) {
      break;
    }

    int x = radius;
    int y = 0;
    int err = 0;

    while (x >= y) {
      SDL_RenderDrawPoint(win->renderer, cx + x, cy + y);
      SDL_RenderDrawPoint(win->renderer, cx + y, cy + x);
      SDL_RenderDrawPoint(win->renderer, cx - y, cy + x);
      SDL_RenderDrawPoint(win->renderer, cx - x, cy + y);
      SDL_RenderDrawPoint(win->renderer, cx - x, cy - y);
      SDL_RenderDrawPoint(win->renderer, cx - y, cy - x);
      SDL_RenderDrawPoint(win->renderer, cx + y, cy - x);
      SDL_RenderDrawPoint(win->renderer, cx + x, cy - y);

      y++;

      if (err <= 0) {
        err += 2 * y + 1;
      }

      if (err > 0) {
        x--;
        err -= 2 * x + 1;
      }
    }
  }

  return 0;
}

// ctx:circ_fill(x, y, r);
static int l_gfx2d_circ_fill(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int cx = luaL_checknumber(L, 2);
  int cy = luaL_checknumber(L, 3);
  int r = luaL_checknumber(L, 4);

  SDL_SetRenderDrawColor(win->renderer, win->color.r, win->color.g, win->color.b, win->color.a);

  for (int y = -r; y <= r; y++) {
    int dx = sqrt(r * r - y * y);
    SDL_RenderDrawLine(win->renderer, cx - dx, cy + y, cx + dx, cy + y);
  }

  return 0;
}

// ctx:arc(x, y, r, start_angle, end_angle);
static int l_gfx2d_arc(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int cx = luaL_checknumber(L, 2);
  int cy = luaL_checknumber(L, 3);
  int r = luaL_checknumber(L, 4);
  double start = luaL_checknumber(L, 5);
  double end = luaL_checknumber(L, 6);

  SDL_SetRenderDrawColor(win->renderer,
    win->color.r,
    win->color.g,
    win->color.b,
    win->color.a);

  if (end < start) {
    double tmp = start;
    start = end;
    end = tmp;
  }

  for (int t = 0; t < win->line_width; t++) {
    int radius = r - t;
    if (radius <= 0) {
      break;
    }

    for (double a = start; a <= end; a += 1.0) {
      double rad = a * M_PI / 180.0;

      int x = cx + (int)round(cos(rad) * radius);
      int y = cy + (int)round(sin(rad) * radius);

      SDL_RenderDrawPoint(win->renderer, x, y);
    }
  }

  return 0;
}

// ctx:arc_fill(x, y, r, start_angle, end_angle);
static int l_gfx2d_arc_fill(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int cx = luaL_checknumber(L, 2);
  int cy = luaL_checknumber(L, 3);
  int r = luaL_checknumber(L, 4);
  double start = luaL_checknumber(L, 5);
  double end = luaL_checknumber(L, 6);

  SDL_SetRenderDrawColor(win->renderer,
    win->color.r,
    win->color.g,
    win->color.b,
    win->color.a);

  if (end < start) {
    double tmp = start;
    start = end;
    end = tmp;
  }

  for (double a = start; a < end; a += 1.0) {
    double rad1 = a * M_PI / 180.0;
    double rad2 = (a + 1.0) * M_PI / 180.0;

    int x1 = cx + (int)round(cos(rad1) * r);
    int y1 = cy + (int)round(sin(rad1) * r);

    int x2 = cx + (int)round(cos(rad2) * r);
    int y2 = cy + (int)round(sin(rad2) * r);

    SDL_Vertex verts[3] = {
      {
        .position = {cx, cy},
        .color = win->color,
        .tex_coord = {0, 0}
      },
      {
        .position = {x1, y1},
        .color = win->color,
        .tex_coord = {0, 0}
      },
      {
        .position = {x2, y2},
        .color = win->color,
        .tex_coord = {0, 0}
      }
    };

    SDL_RenderGeometry(win->renderer, NULL, verts, 3, NULL, 0);
  }

  return 0;
}

// ctx:tri(x1, y1, x2, y2, x3, y3);
static int l_gfx2d_tri(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  int x1 = luaL_checknumber(L, 2);
  int y1 = luaL_checknumber(L, 3);
  int x2 = luaL_checknumber(L, 4);
  int y2 = luaL_checknumber(L, 5);
  int x3 = luaL_checknumber(L, 6);
  int y3 = luaL_checknumber(L, 7);

  SDL_SetRenderDrawColor(win->renderer,
    win->color.r,
    win->color.g,
    win->color.b,
    win->color.a);

  int half = win->line_width / 2;

  for (int i = -half; i <= half; i++) {
    SDL_RenderDrawLine(win->renderer, x1 + i, y1, x2 + i, y2);
    SDL_RenderDrawLine(win->renderer, x2 + i, y2, x3 + i, y3);
    SDL_RenderDrawLine(win->renderer, x3 + i, y3, x1 + i, y1);

    SDL_RenderDrawLine(win->renderer, x1, y1 + i, x2, y2 + i);
    SDL_RenderDrawLine(win->renderer, x2, y2 + i, x3, y3 + i);
    SDL_RenderDrawLine(win->renderer, x3, y3 + i, x1, y1 + i);
  }

  return 0;
}

static void fill_flat_bottom(SDL_Renderer *renderer,
  float x1, float y1,
  float x2, float y2,
  float x3, float y3) {
  float invslope1 = (x2 - x1) / (y2 - y1);
  float invslope2 = (x3 - x1) / (y3 - y1);

  float curx1 = x1;
  float curx2 = x1;

  for (int y = (int)y1; y <= (int)y2; y++) {
    SDL_RenderDrawLine(renderer, (int)curx1, y, (int)curx2, y);
    curx1 += invslope1;
    curx2 += invslope2;
  }
}

static void fill_flat_top(SDL_Renderer *renderer,
  float x1, float y1,
  float x2, float y2,
  float x3, float y3) {
  float invslope1 = (x3 - x1) / (y3 - y1);
  float invslope2 = (x3 - x2) / (y3 - y2);

  float curx1 = x3;
  float curx2 = x3;

  for (int y = (int)y3; y >= (int)y1; y--) {
    SDL_RenderDrawLine(renderer, (int)curx1, y, (int)curx2, y);
    curx1 -= invslope1;
    curx2 -= invslope2;
  }
}

// ctx:tri_fill(x1, y1, x2, y2, x3, y3);
static int l_gfx2d_tri_fill(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  float x1 = luaL_checknumber(L, 2);
  float y1 = luaL_checknumber(L, 3);
  float x2 = luaL_checknumber(L, 4);
  float y2 = luaL_checknumber(L, 5);
  float x3 = luaL_checknumber(L, 6);
  float y3 = luaL_checknumber(L, 7);

  SDL_SetRenderDrawColor(win->renderer,
    win->color.r,
    win->color.g,
    win->color.b,
    win->color.a);

  if (y1 > y2) {
    float t;
    t = x1; x1 = x2; x2 = t;
    t = y1; y1 = y2; y2 = t;
  }

  if (y1 > y3) {
    float t;
    t = x1; x1 = x3; x3 = t;
    t = y1; y1 = y3; y3 = t;
  }

  if (y2 > y3) {
    float t;
    t = x2; x2 = x3; x3 = t;
    t = y2; y2 = y3; y3 = t;
  }

  if (y2 == y3) {
    fill_flat_bottom(win->renderer, x1, y1, x2, y2, x3, y3);
  } else if (y1 == y2) {
    fill_flat_top(win->renderer, x1, y1, x2, y2, x3, y3);
  } else {
    float x4 = x1 + ((y2 - y1) / (y3 - y1)) * (x3 - x1);

    fill_flat_bottom(win->renderer, x1, y1, x2, y2, x4, y2);
    fill_flat_top(win->renderer, x2, y2, x4, y2, x3, y3);
  }

  return 0;
}

// ctx:clear();
static int l_gfx2d_clear(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  SDL_SetRenderDrawColor(win->renderer, win->color.r, win->color.g, win->color.b, win->color.a);
  SDL_RenderClear(win->renderer);
  return 0;
}

// ctx:target_fps(target_fps?) 
static int l_gfx2d_target_fps(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);
  int target_fps = luaL_checknumber(L, 2);
  win->target_fps = target_fps;
  lua_pushnumber(L, win->target_fps);
  return 1;
}

// ctx:delta_time()
static int l_gfx2d_delta_time(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);
  lua_pushnumber(L, (float)(win->delta_time)/1000);
  return 1;
}

// ctx:end_frame() 
static int l_gfx2d_end_frame(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
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
  lunar_window *win = lua_touserdata(L, -1);
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
  lua_pushcfunction(L, l_gfx2d_image);
  lua_setfield(L, -2, "image");
  lua_pushcfunction(L, l_gfx2d_image_part);
  lua_setfield(L, -2, "image_part");

  lua_pushcfunction(L, l_gfx2d_line_width);
  lua_setfield(L, -2, "line_width");
  lua_pushcfunction(L, l_gfx2d_pixel);
  lua_setfield(L, -2, "pixel");
  lua_pushcfunction(L, l_gfx2d_line);
  lua_setfield(L, -2, "line");
  lua_pushcfunction(L, l_gfx2d_rect);
  lua_setfield(L, -2, "rect");
  lua_pushcfunction(L, l_gfx2d_rect_fill);
  lua_setfield(L, -2, "rect_fill");
  lua_pushcfunction(L, l_gfx2d_circ);
  lua_setfield(L, -2, "circ");
  lua_pushcfunction(L, l_gfx2d_circ_fill);
  lua_setfield(L, -2, "circ_fill");
  lua_pushcfunction(L, l_gfx2d_arc);
  lua_setfield(L, -2, "arc");
  lua_pushcfunction(L, l_gfx2d_arc_fill);
  lua_setfield(L, -2, "arc_fill");
  lua_pushcfunction(L, l_gfx2d_tri);
  lua_setfield(L, -2, "tri");
  lua_pushcfunction(L, l_gfx2d_tri_fill);
  lua_setfield(L, -2, "tri_fill");
  return 1;
}

// win:quit()
static int l_win_quit(lua_State *L) {
  lua_getfield(L, 1, "_handle");
  lunar_window *win = lua_touserdata(L, -1);
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

  if (!lunar_inited) {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
      return luaL_error(L, "SDL_Init: %s", SDL_GetError());
    }

    if (TTF_Init() == -1) {
      return luaL_error(L, "TTF_Init: %s", TTF_GetError());
    }

    lunar_inited = true;
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

  lunar_window *win = lua_newuserdata(L, sizeof(*win));
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
  win->line_width = 1;

  memset(win->key_held, 0, sizeof(win->key_held));
  memset(win->key_down, 0, sizeof(win->key_down));
  memset(win->key_up, 0, sizeof(win->key_up));

  luaL_getmetatable(L, "lunar.window");
  lua_setmetatable(L, -2);
  lua_setfield(L, -2, "_handle");
  return 1;
}

static lunar_input *input_check(lua_State *L) {
  lua_getfield(L, 1, "_handle");
  lunar_input *input = lua_touserdata(L, -1);
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

// input:mouse()
static int l_input_mouse(lua_State *L) {
  int x, y;
  uint32_t buttons = SDL_GetMouseState(&x, &y);
  lua_pushnumber(L, x);
  lua_pushnumber(L, y);
  lua_pushboolean(L, buttons & SDL_BUTTON(SDL_BUTTON_LEFT));
  lua_pushboolean(L, buttons & SDL_BUTTON(SDL_BUTTON_RIGHT));
  lua_pushboolean(L, buttons & SDL_BUTTON(SDL_BUTTON_MIDDLE));
  return 5;
}

// input:init(backend, win)
static int l_input_init(lua_State *L) {
  const char *backend = luaL_checkstring(L, 2);
  if (strcmp(backend, "sdl") != 0) {
    return luaL_error(L, "unknown backend: %s", backend);
  }

  lua_getfield(L, 3, "_handle");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  lunar_input *input = lua_newuserdata(L, sizeof(*input));
  input->window = win;
  input->backend = lunar_BACKEND_SDL;
  luaL_getmetatable(L, "lunar.input");
  lua_setmetatable(L, -2);
  lua_setfield(L, 1, "_handle");
  return 0;
}

// assets:image(path)
static int l_assets_image(lua_State *L) {
  lua_getfield(L, 1, "_win");
  lunar_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);
  const char *path = luaL_checkstring(L, 2);

  SDL_Surface *surface = IMG_Load(path);
  if (!surface) {
    luaL_error(L, "couldnt find image: %s", path);
  }
  SDL_Texture *texture = SDL_CreateTextureFromSurface(win->renderer, surface);
  
  lua_newtable(L); 
  lua_pushnumber(L, surface->w);
  lua_setfield(L, -2, "width");
  lua_pushnumber(L, surface->h);
  lua_setfield(L, -2, "height");
  lua_pushlightuserdata(L, texture);
  lua_setfield(L, -2, "image");
  SDL_FreeSurface(surface);
  return 1;
}

static int l_assets_init(lua_State *L) {
  const char *backend = luaL_checkstring(L, 2);
  if (strcmp(backend, "sdl") != 0) {
    return luaL_error(L, "unknown backend: %s", backend);
  }

  lua_getfield(L, 3, "_handle");
  lua_setfield(L, 1, "_win");
  return 0;
}

static int service_gfx2d(lua_State *L) {
  lua_newtable(L);
  
  lua_pushcfunction(L, l_gfx2d_init);
  lua_setfield(L, -2, "init");
  return 1;
}

static int service_input(lua_State *L) {
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
  
  lua_pushcfunction(L, l_input_mouse);
  lua_setfield(L, -2, "mouse");
  return 1;
}

static int service_assets(lua_State *L) {
  lua_newtable(L);

  lua_pushcfunction(L, l_assets_init);
  lua_setfield(L, -2, "init");
  lua_pushcfunction(L, l_assets_image);
  lua_setfield(L, -2, "image");
  return 1;
}

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

// local gfx = lunar:getservice(service_name);
static int l_getservice(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);
  lunar_service service = lunar_search_service(name);
  return service.service(L);
}

void lunar_init() {
  lunar_state = luaL_newstate();
  luaL_openlibs(lunar_state);

  lua_newtable(lunar_state);

  lua_pushcfunction(lunar_state, l_getservice);
  lua_setfield(lunar_state, -2, "getservice");
  lua_pushcfunction(lunar_state, l_wait);
  lua_setfield(lunar_state, -2, "wait");
  lua_pushcfunction(lunar_state, l_time);
  lua_setfield(lunar_state, -2, "time");

  lua_pushcfunction(lunar_state, l_log);
  lua_setfield(lunar_state, -2, "log");
  lua_pushcfunction(lunar_state, l_info);
  lua_setfield(lunar_state, -2, "info");
  lua_pushcfunction(lunar_state, l_warn);
  lua_setfield(lunar_state, -2, "warn");
  lua_pushcfunction(lunar_state, l_error);
  lua_setfield(lunar_state, -2, "error");
  lua_pushcfunction(lunar_state, l_fatal);
  lua_setfield(lunar_state, -2, "fatal");

  lua_pushstring(lunar_state, "Lunar v"LUNAR_VERSION);
  lua_setfield(lunar_state, -2, "version");

  lunar_service gfx2d_service = {
    .name = "gfx:2d",
    .service = service_gfx2d
  };
  lunar_service input_service = {
    .name = "input",
    .service = service_input
  };
  lunar_service assets_service = {
    .name = "assets",
    .service = service_assets
  };

  lunar_add_service(gfx2d_service);
  lunar_add_service(input_service);
  lunar_add_service(assets_service);

  lua_setglobal(lunar_state, "lunar");
}

void lunar_quit() {
  lua_close(lunar_state);
  TTF_Quit();
  SDL_Quit();
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
