
local unittest = require 'unittest'

local tests = {}

function tests.test_a ()

    unittest.assert.equals (1, 2)

end

local result = unittest.run (tests)
print (result:summary ())

return tests