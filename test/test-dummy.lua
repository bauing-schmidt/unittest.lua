
local unittest = require 'unittest'

local tests = {}

function tests:test_a ()

    unittest.assert.equals (1, 1)

end


return tests