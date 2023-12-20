
local unittest = require 'unittest'

local tests = {}

function tests.test_assert_equals_numbers ()
    assert (pcall(unittest.assert.equals, 1, 1))
end

function tests.test_assert_equals_tables ()
    assert(pcall (unittest.assert.equals, {}, {}))
    assert(pcall (unittest.assert.equals, {1,2,3}, {1,2,3}))
    assert(pcall (unittest.assert.equals, {{}}, {{}}))
    assert(pcall (unittest.assert.equals, {[{}] = 'hello', [{}] = 'world'}, {[{}] = 'world', [{}] = 'hello'}))
end

function tests.test_assert_same ()
    assert(pcall (unittest.assert.same, 1, 1))
    assert(pcall (unittest.assert.same, 'hello', 'hel' .. 'lo'))
end

function tests.test_assert_deny ()
    assert(pcall (unittest.deny.equals, 1, 2))
    assert(pcall (unittest.deny.equals, {}, 1))
    assert(pcall (unittest.deny.equals, {1}, {1, 2}))
    assert(pcall (unittest.deny.equals, {hello = 1}, {hello = 'world'}))
    assert(pcall (unittest.deny.same, {1,2,3}, {1,2,3}))
end

function tests.test_msg ()
    local flag, msg = pcall (unittest.assert.equals, 1, 2)
    
    assert (not flag)
    
    assert (msg == [[
/usr/local/share/lua/5.4/unittest.lua:245: Expected:
  2
Actual:
  1]])
  
end

local result = unittest.run (tests)
print (result:summary ())

return tests