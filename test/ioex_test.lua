local ioex = require('ioex')
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

function testcase.tofile()
    local f = assert(io.open(FILENAME, 'r+'))
    assert(f:write('hello'))
    assert(f:flush())

    -- test that wraps a fd to new lua file handle
    local fd = ioex.fileno(f)
    local newf = assert(ioex.tofile(fd, 'a+'))
    assert.not_equal(ioex.fileno(newf), fd)
    f:close()

    -- test write a data
    assert(newf:write(' world!'))
    assert(newf:seek('set', 0))
    assert.equal(newf:read('*a'), 'hello world!')

    newf:close()
end

function testcase.isfile()
    local f = assert(io.open(FILENAME, 'r+'))
    local mt = getmetatable(f)

    -- test that returns true
    assert.is_true(ioex.isfile(f))

    -- test that returns false
    local fake = setmetatable({}, mt)
    for _, v in ipairs({
        fake,
        'foo',
        1,
        {},
        function()
        end,
    }) do
        assert.is_false(ioex.isfile(v))
    end
    setmetatable(fake, nil)
end
