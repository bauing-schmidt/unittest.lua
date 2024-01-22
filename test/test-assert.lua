
local unittest = require 'unittest'

local tests = {}

function tests:test_assert_equals_numbers ()
    assert (pcall(unittest.assert.equals '' (1), 1))
end

function tests:test_nested_tables ()

    local t = {1, 2, 3, {4, 5, 6, {7, 8, 9}}}
    local error_flag, msg = pcall(unittest.assert.equals 'Two different (nested) tables.' 
        {[t] = { second = {1}}}, {{third = {fourth = {five = 'hello'}}}})

    assert (not error_flag)
    assert (msg == [[
Two different (nested) tables.
Expected:
{
  [1] = {
    [{
      [1] = 1,
      [2] = 2,
      [3] = 3,
      [4] = {
        [1] = 4,
        [2] = 5,
        [3] = 6,
        [4] = {
          [1] = 7,
          [2] = 8,
          [3] = 9,
        },
      },
    }] = {
      second = {
        [1] = 1,
      },
    },
  },
  n = 1,
}
Actual:
{
  [1] = {
    [1] = {
      third = {
        fourth = {
          five = 'hello',
        },
      },
    },
  },
  n = 1,
}]], msg)
end

function tests:test_assert_equals_tables ()
    assert(pcall (unittest.assert.equals 'Two empty tables are equal.' {}, {}))
    assert(pcall (unittest.assert.equals '' {1,2,3}, {1,2,3}))
    assert(pcall (unittest.assert.equals '' {{}}, {{}}))
    assert(pcall (unittest.assert.equals '' {[{}] = 'hello', [{}] = 'world'}, {[{}] = 'world', [{}] = 'hello'}))
end

function tests:test_assert_same ()
    assert(pcall (unittest.assert.same (1), 1))
    assert(pcall (unittest.assert.same 'hello', 'hel' .. 'lo'))
end

function tests:test_assert_deny ()
    assert(pcall (unittest.deny.equals '' (1), 2))
    assert(pcall (unittest.deny.equals '' {}, 1))
    assert(pcall (unittest.deny.equals '' {1}, {1, 2}))
    assert(pcall (unittest.deny.equals '' {hello = 1}, {hello = 'world'}))
    assert(pcall (unittest.deny.same {1,2,3}, {1,2,3}))
end

function tests:test_assert_istrue ()
    assert(pcall (unittest.assert.istrue '' , true))
    assert(not pcall (unittest.assert.istrue '' , false))
    assert(not pcall (unittest.assert.istrue '' , 4))
    assert(not pcall (unittest.assert.istrue '' , 'hello'))
    assert(not pcall (unittest.assert.istrue '' , function () end))
end

function tests:test_assert_isfalse ()
    assert(pcall (unittest.assert.isfalse '' , false))
    assert(not pcall (unittest.assert.isfalse '' , true))
    assert(not pcall (unittest.assert.isfalse '' , 4))
    assert(not pcall (unittest.assert.isfalse '' , 'hello'))
    assert(not pcall (unittest.assert.isfalse '' , function () end))
end

function tests:test_msg ()
    local flag, msg = pcall (unittest.assert.equals 'error message' (2), 1)
    
    assert (not flag)
    assert (msg == [[
error message
Expected:
{
  [1] = 2,
  n = 1,
}
Actual:
{
  [1] = 1,
  n = 1,
}]], msg)

end

return tests