
local unittest = require 'unittest'

local tests = {}

function tests.test_assert_equals_numbers (recv)

    assert(unittest.assert.equals (1, 1))
    assert(not unittest.assert.equals (1, 2))

end


function tests.test_assert_equals_tables (recv)

    assert(unittest.assert.equals ({}, {}))
    assert(unittest.assert.equals ({1,2,3}, {1,2,3}))
    assert(unittest.assert.equals ({{}}, {{}}))
    assert(unittest.assert.equals ({[{}] = 'hello', [{}] = 'world'}, {[{}] = 'world', [{}] = 'hello'}))

end


function tests.test_assert_deny (recv)
    assert(unittest.deny.equals ({}, 1))
    assert(unittest.deny.equals ({1}, {1, 2}))
    assert(unittest.deny.equals ({hello = 1}, {hello = 'world'}))
    assert(unittest.deny.same ({1,2,3}, {1,2,3}))
end


function tests.test_assert_same (recv)
    assert(unittest.assert.same (1, 1))
    assert(unittest.assert.same ('hello', 'hel' .. 'lo'))
end


local result = unittest.run (tests)
print (result:summary ())

return tests