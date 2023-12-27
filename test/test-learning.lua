
local unittest = require 'unittest'

local tests = {}

function tests.test_empty_strings ()

    unittest.assert.equals '' [[]]
    unittest.assert.equals '' [[
]]
    unittest.deny.equals '' [[

]]

end

function tests.test_string_byte ()

    unittest.assert.equals (104, 101, 108, 108, 111) (string.byte ('hello', 1, 5))
    unittest.assert.equals (104, 101, 108, 108, 111) (string.byte ('hello', 1, -1))

end


function tests.test_string_compare ()

    unittest.assert.istrue ('a' < 'b')
    unittest.assert.isfalse ('b' < 'a')
    unittest.assert.istrue ('aa' < 'ab')

    local strings = { 'ba', 'a', 'hello' }
    table.sort (strings)
    unittest.assert.equals {'a', 'ba', 'hello'} (strings)

end

return tests