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
- functions of `ioex.fileno` module
- functions of `ioex.file` module


## fd = ioex.fileno( f )

get the file descriptor from the file handle.

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


## f, err = ioex.file( fd )

create the file handle from the file descriptor.

**Parameters**

- `fd:integer`: the file descriptor.

**Returns**

- `f:file`: lua file handle.
- `err:string`: error string

**e.g.**

```lua
local io = require('ioex')
local f = assert(io.open('./test.txt', 'w'))
local fd = io.fileno(f)

-- returns new file handle from the file descriptor
local newf = assert(io.file(fd))
-- file descriptor is duplicated with the `dup` function
print(io.fileno(newf)) 
```

