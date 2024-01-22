
local unittest = require 'unittest'

local tests = {}

function tests:test_dummy ()

    unittest.assert.equals (1, 1)

end


return tests