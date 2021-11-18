local ioex = require('ioex')
local assert = require('assertex')
local testcase = require('testcase')

local FILENAME = 'testfile.txt'

function testcase.after_all()
    os.remove(FILENAME)
end

function testcase.builtins()
    for k, v in pairs(io) do
        -- ignore stderr and stdout that are replaced by testcase
        if k ~= 'stdout' and k ~= 'stderr' then
            assert.equal(v, ioex[k])
        end
    end
end

function testcase.fileno()
    local f = assert(io.open(FILENAME, 'w'))

    -- test that returns n greater than 2
    assert.greater(ioex.fileno(f), 2)

    -- test that returns -1 after closed
    f:close()
    assert.equal(ioex.fileno(f), -1)
end

function testcase.file()
    local f = assert(io.open(FILENAME, 'r+'))
    assert(f:write('hello'))
    assert(f:flush())

    -- test that wraps a fd to new lua file handle
    local fd = ioex.fileno(f)
    local newf = assert( ioex.file(fd, 'a+'))
    assert.not_equal(ioex.fileno(newf), fd)
    f:close()

    -- test write a data
    assert(newf:write(' world!'))
    assert(newf:seek('set', 0))
    assert.equal(newf:read('*a'), 'hello world!')

    newf:close()
end
