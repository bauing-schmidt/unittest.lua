
local unittest = require 'unittest'

local tests = {}

function tests:test_empty_strings ()

    unittest.assert.equals 'Two empty strings' '' [[]]
    unittest.assert.equals 'Two empty strings, using multilines delimiter' '' [[
]]
    unittest.deny.equals 'Two empty strings, using multilines delimiter with first empty line' '' [[

]]

end

function tests:test_string_byte ()

    unittest.assert.equals 'Byte codes using the string length.' (104, 101, 108, 108, 111) (string.byte ('hello', 1, 5))
    unittest.assert.equals 'Byte codes using -1 as end index.' (104, 101, 108, 108, 111) (string.byte ('hello', 1, -1))

end

function tests:test_string_metatable ()

    local hello_mt = getmetatable 'hello'

    unittest.assert.istrue 'Strings have a non-nil metatable' (hello_mt ~= nil)
    unittest.assert.equals 'Strings have the same metatable' (hello_mt) (getmetatable 'world')
    unittest.assert.equals 'Strings have the same metatable, even the empty string' (hello_mt) (getmetatable '')

end


function tests:test_string_metatable_find ()

    local hello = 'hello'
    unittest.assert.equals '"l" should be at position 3 in "hello"' (3, 3) (hello:find 'l')  

end

function tests:test_string_find ()

    unittest.assert.equals '"l" is at position 3 in "hello"' (3, 3) (string.find('hello', 'l', 1, true))

end

function tests:test_string_compare ()

    unittest.assert.istrue '' ('a' < 'b')
    unittest.assert.isfalse '' ('b' < 'a')
    unittest.assert.istrue '' ('aa' < 'ab')

    local strings = { 'ba', 'a', 'hello' }
    table.sort (strings)
    unittest.assert.equals 'They don\'t respect the alphanumeric ordering.' {'a', 'ba', 'hello'} (strings)

end


function tests:test_gc ()

    local called = false
    do 
        local mt = { __gc = function (self) called = true end }
        local s = setmetatable ({}, mt)
    end

    collectgarbage()

    unittest.assert.istrue '' (called)
end


function tests:test_close ()

    local called = false
    local t = {}
    do 
        local mt = { __close = function (self, err) called = true end }
        local s <close> = setmetatable ({}, mt)
        t[1] = s
    end

    unittest.assert.istrue '' (called)
end

return tests