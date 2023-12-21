
local unittest = require 'unittest'

local tests = {}

function tests.test_string_byte ()

    unittest.assert.equals (table.pack (string.byte ('hello', 1, -1)), {104, 101, 108, 108, 111, n = 5})

end

return tests