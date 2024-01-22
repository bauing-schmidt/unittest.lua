
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


function tests:test_string_compare ()

    unittest.assert.istrue ('a' < 'b')
    unittest.assert.isfalse ('b' < 'a')
    unittest.assert.istrue ('aa' < 'ab')

    local strings = { 'ba', 'a', 'hello' }
    table.sort (strings)
    unittest.assert.equals 'They don\'t respect the alphanumeric ordering.' {'a', 'ba', 'hello'} (strings)

end

return tests