#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#define LUNAR_IMPLEMENTATION
#include "lunar.h"

int main(int argc, char **argv) {
  argc=argc;
  char *pathname = argv[1];
  if (pathname == NULL) {
    pathname = "main.lua";
  }

  lunar_init();
  const char *err_msg = lunar_run(pathname);
  if (err_msg != NULL) {
    printf("\033[31m[error]\033[0m %s\n", err_msg);
  }
  lunar_quit();
  return 0;
}
