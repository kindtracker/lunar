#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#define MENGINE_IMPLEMENTATION
#include "mengine.h"

int main(int argc, char **argv) {
  argc=argc;
  char *pathname = argv[1];
  if (pathname == NULL) {
    pathname = "main.lua";
  }

  mengine_init();
  const char *err_msg = mengine_run(pathname);
  if (err_msg != NULL) {
    printf("%s\n", err_msg);
  }
  mengine_quit();
  return 0;
}
