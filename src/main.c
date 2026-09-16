#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>

#define LUNAR_IMPLEMENTATION
#include "lunar.h"

int main(int argc, char **argv) {
  argc = argc;
  char *FilePath = argv[1];
  if (FilePath == NULL) {
    FilePath = "main.lua";
  }

  LunarInit();
  const char *ErrorMessage = LunarRun(FilePath);
  if (ErrorMessage != NULL) {
    fprintf(stderr, "[Lunar] runtime error: %s\n", ErrorMessage);
  }
  LunarQuit();
  return 0;
}
