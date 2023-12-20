
local unittest = require 'unittest'

local tests = {}

function tests.test_assert_equals_numbers (recv)
    assert (pcall(unittest.assert.equals, 1, 1))
end

function tests.test_assert_equals_tables (recv)
    assert(pcall (unittest.assert.equals, {}, {}))
    assert(pcall (unittest.assert.equals, {1,2,3}, {1,2,3}))
    assert(pcall (unittest.assert.equals, {{}}, {{}}))
    assert(pcall (unittest.assert.equals, {[{}] = 'hello', [{}] = 'world'}, {[{}] = 'world', [{}] = 'hello'}))
end

function tests.test_assert_same (recv)
    assert(pcall (unittest.assert.same, 1, 1))
    assert(pcall (unittest.assert.same, 'hello', 'hel' .. 'lo'))
end

function tests.test_assert_deny (recv)
    assert(pcall (unittest.deny.equals, 1, 2))
    assert(pcall (unittest.deny.equals, {}, 1))
    assert(pcall (unittest.deny.equals, {1}, {1, 2}))
    assert(pcall (unittest.deny.equals, {hello = 1}, {hello = 'world'}))
    assert(pcall (unittest.deny.same, {1,2,3}, {1,2,3}))
end

local result = unittest.run (tests)
print (result:summary ())

return tests