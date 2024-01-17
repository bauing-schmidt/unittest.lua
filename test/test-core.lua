
local unittest = require 'unittest'

local t = unittest.bootstrap.case 'test_running'

function t:test_running ()
    local t = unittest.bootstrap.wasrun 'test_method'

    print (t.wasrun)
    t:run ()
    print (t.wasrun)
end

t:run ()