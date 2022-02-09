rockspec_format = '3.0'
package = 'ioex'
version = 'dev-1'
source = {
    url = 'git+https://github.com/mah0x211/lua-ioex.git',
}
description = {
    summary = 'additional features to the io module.',
    homepage = 'https://github.com/mah0x211/lua-ioex',
    license = 'MIT/X11',
    maintainer = 'Masatoshi Fukunaga',
}
dependencies = {
    'lua >= 5.1'
}
build = {
    type = 'builtin',
    modules = {
        ioex = 'ioex.lua',
        ['ioex.tofile'] = {
            sources = { 'src/tofile.c' },
            incdirs = { 'deps/lauxhlib' },
        },
        ['ioex.fileno'] = {
            sources = { 'src/fileno.c' },
            incdirs = { 'deps/lauxhlib' },
        },
        ['ioex.isfile'] = {
            sources = { 'src/isfile.c' },
            incdirs = { 'deps/lauxhlib' },
        },
    }
}
