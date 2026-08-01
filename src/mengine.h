#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

extern lua_State *mengine_state;

extern void mengine_init();
extern const char *mengine_run(const char *pathname);
extern void mengine_free();

#ifdef MENGINE_IMPLEMENTATION
#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>

lua_State *mengine_state;
bool inited = false;

typedef struct {
    SDL_Window *window;
    SDL_Renderer *renderer;
    SDL_Texture *texture;
    TTF_Font *font;
} mengine_window;

// ctx:text("meow", 0, 0);
static int l_gfx2d_text(lua_State *L) {
  lua_getfield(L, 1, "_win");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  const char *text = luaL_checkstring(L, 2);
  int x = luaL_checkinteger(L, 3);
  int y = luaL_checkinteger(L, 4);

  SDL_Color color = {255, 255, 255, 255};

  SDL_Surface *surface = TTF_RenderUTF8_Blended(win->font, text, color);
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

  printf("win: %p\n", win);

  int a = SDL_SetRenderDrawColor(win->renderer, 0, 0, 0, 255);
  printf("a: %d\n", a);
  a = SDL_RenderClear(win->renderer);
  printf("b: %d\n", a);
  return 0;
}

// ctx:end_frame() 
static int l_gfx2d_end_frame(lua_State *L) {
  lua_getfield(L, 1, "_win");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);
  SDL_RenderPresent(win->renderer);
  return 0;
}

// local ctx = win:getcontext()
static int l_gfx2d_getcontext(lua_State *L) {
  lua_getfield(L, 1, "_handle");
  mengine_window *win = lua_touserdata(L, -1);
  lua_pop(L, 1);

  lua_newtable(L);
  lua_pushlightuserdata(L, win);
  lua_setfield(L, -2, "_win");
  lua_pushcfunction(L, l_gfx2d_text);
  lua_setfield(L, -2, "text");
  lua_pushcfunction(L, l_gfx2d_clear);
  lua_setfield(L, -2, "clear");
  lua_pushcfunction(L, l_gfx2d_end_frame);
  lua_setfield(L, -2, "end_frame");
  return 1;
}

// win:free()
static int l_win_free(lua_State *L) {
  lua_getfield(L, 1, "_handle");
  mengine_window *win = lua_touserdata(L, -1);
  if (win->texture) SDL_DestroyTexture(win->texture);
  if (win->renderer) SDL_DestroyRenderer(win->renderer);
  if (win->window) SDL_DestroyWindow(win->window);
  if (win->font) TTF_CloseFont(win->font);
  lua_pop(L, 1);
  return 0;
}

// local win = gfx:init("meow", 800, 600);
static int l_gfx2d_init(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);
  int width = luaL_checkinteger(L, 3);
  int height = luaL_checkinteger(L, 4);

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

  lua_pushcfunction(L, l_win_free);
  lua_setfield(L, -2, "free");

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
        
  luaL_getmetatable(L, "mengine.window");
  lua_setmetatable(L, -2);

  lua_setfield(L, -2, "_handle");

  return 1;
}

void service_gfx2d(lua_State *L) {
  lua_newtable(L);
  
  lua_pushcfunction(L, l_gfx2d_init);
  lua_setfield(L, -2, "init");
}

// local gfx = mengine:getservice("gfx:2d");
int l_getservice(lua_State *L) {
  const char *name = luaL_checkstring(L, 2);

  if (strcmp(name, "gfx:2d") == 0) {
    service_gfx2d(L);
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
