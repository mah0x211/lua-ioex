# lua-ioex

[![test](https://github.com/mah0x211/lua-ioex/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-ioex/actions/workflows/test.yml)

additional features to the io module.

---


## Installation

```
luarocks install ioex
```

`ioex` module contains the following functions;

- functions of Lua's built-in `io` module
- `ioex.fileno` function
- `ioex.file` function
- `ioex.isfile` function


## fd = ioex.fileno( f )

get the file descriptor from the lua file handle.

**Parameters**

- `f:file`: lua file handle.

**Returns**

- `fd:integer`: the file descriptor.

**e.g.**

```lua
local io = require('ioex')
local f = assert(io.open('./test.txt', 'w'))

-- returns a file descriptor that greater than 0
print(io.fileno(f)) 

f:close()
-- returns -1
print(io.fileno(f))
```


## f, err, errno = ioex.tofile( fd [, mode] )

create the lua file handle from the file descriptor.

**Parameters**

- `fd:integer`: the file descriptor.
- `mode:string`: the mode string can be any of the following:
  - `'r'`: read mode (the default);
  - `'w'`: write mode;
  - `'a'`: append mode;
  - `'r+'`: update mode, all previous data is preserved;
  - `'w+'`: update mode, all previous data is erased;
  - `'a+'`: append update mode, previous data is preserved, writing is only allowed at the end of file.

**Returns**

- `f:file`: lua file handle.
- `err:string`: error string.
- `errno:integer`: error number.

**e.g.**

```lua
local io = require('ioex')
local f = assert(io.open('./test.txt', 'w'))
local fd = io.fileno(f)

-- returns new file handle from the file descriptor
local newf = assert(io.tofile(fd))
-- file descriptor is duplicated with the `dup` function
print(io.fileno(newf)) 
```


## ok = ioex.isfile( f )

determines whether `f` is the lua file handle or not.

**Parameters**

- `f:any`: any value.

**Returns**

- `ok:boolean`: `true` if `f` is the lua file handle.

**e.g.**

```lua
local io = require('ioex')
local f = assert(io.open('./test.txt', 'w'))
local mt = getmetatable(f)
local fake = setmetatable({}, mt)

-- true
print(io.isfile(f)) 
-- false
print(io.isfile(fake))
print(io.isfile('foo'))
print(io.isfile(1))
```

