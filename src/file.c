/**
 *  Copyright (C) 2021 Masatoshi Fukunaga
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to
 *  deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 *
 */
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
// lua
#include "lauxhlib.h"

static inline FILE *fd2fp(int fd, const char *mode)
{
    FILE *fp = NULL;

    // duplicate a fd
    if (fd > -1 && (fd = dup(fd)) == -1) {
        return NULL;
    } else if ((fp = fdopen(fd, mode))) {
        return fp;
    } else if (fd > 0) {
        close(fd);
    }

    return NULL;
}

static int closefp(lua_State *L)
{
#if LUA_VERSION_NUM >= 502
    luaL_Stream *p = luaL_checkudata(L, 1, LUA_FILEHANDLE);
    int res        = fclose(p->f);
    p->closef      = NULL;
    return luaL_fileresult(L, (res == 0), NULL);

#else
    FILE **p = luaL_checkudata(L, 1, LUA_FILEHANDLE);
    fclose(*p);
    *p = NULL;
    lua_pushboolean(L, 1);
    return 1;

#endif
}

static int file_lua(lua_State *L)
{
    int fd           = lauxh_checkinteger(L, 1);
    const char *mode = lauxh_checkstring(L, 2);

#if LUA_VERSION_NUM >= 502
    luaL_Stream *p = lua_newuserdata(L, sizeof(luaL_Stream));
    FILE **fp      = &p->f;
    p->closef      = closefp;
#else
    FILE **fp = (FILE **)lua_newuserdata(L, sizeof(FILE *));
    *fp       = NULL;
#endif

    *fp = fd2fp(fd, mode);
    if (*fp == NULL) {
        lua_pushnil(L);
        lua_pushstring(L, strerror(errno));
        return 2;
    }

    lauxh_setmetatable(L, LUA_FILEHANDLE);
#if LUA_VERSION_NUM < 502
    lua_createtable(L, 0, 1);
    lua_pushcfunction(L, closefp);
    lua_setfield(L, -2, "__close");
    lua_setfenv(L, -2);
#endif

    return 1;
}

LUALIB_API int luaopen_ioex_file(lua_State *L)
{
    lua_pushcfunction(L, file_lua);
    return 1;
}
