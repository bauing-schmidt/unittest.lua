
local unittest = require 'unittest'

local case = unittest.test_case "test_running"

function case.test_running ()
    local test = unittest.wasrun 'test_method'

    assert (not test.wasrun, 'before')
    test:run ()
    assert (test.wasrun, 'after')
end    

case:run()