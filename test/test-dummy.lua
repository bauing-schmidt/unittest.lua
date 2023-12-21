
local unittest = require 'unittest'

local tests = {}

function tests.test_a ()

    unittest.assert.equals (1, {hello = 'world'})

end

local result = unittest.run (tests)
print (result:summary ())

return tests