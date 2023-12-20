
local unittest = require 'unittest'

local tests = {}
    
function tests.test_template_method (recv)
    local test = unittest.wasrun 'test_method'
    test:run (unittest.new_result ())
    assert (test:logstring () == 'setup test_method teardown')
end

function tests.test_result (recv)

    local test = unittest.wasrun 'test_method'
    local result = unittest.new_result ()
    test:run (result)
    assert ('1 run, 0 failed.' == result:summary ())

end

function tests.test_failed_result (recv)

    local test = unittest.wasrun 'test_broken_method'
    local result = unittest.new_result ()
    test:run (result)
    
    assert (result:summary () == [[
1 run, 1 failed.
test_broken_method: /usr/local/share/lua/5.4/unittest.lua:85: explicitly raised.]])

end

function tests.test_failedresultformatting (recv)

    local result = unittest.new_result ()
    local not_seen = result:started (recv)
    result:failed ({name = 'test_dummy'}, 'no reason.')
    
    assert (not_seen)
    assert (result:summary () == [[
1 run, 1 failed.
test_dummy: no reason.]])

end

function tests.test_cases (recv)

    local cases = unittest.cases ()
    cases:append (unittest.wasrun 'test_method')
    cases:append (unittest.wasrun 'test_broken_method')
    local result = unittest.new_result ()
    cases:run (result)

    assert (result:summary () == [[
2 run, 1 failed.
test_broken_method: /usr/local/share/lua/5.4/unittest.lua:85: explicitly raised.]])

end

function tests.test_suite (recv, result)

    local suite = unittest.suite (tests)
    suite:run (result)
    assert (result:summary () == '7 run, 0 failed.')

end


function tests.test_api_run (recv, result)

    unittest.run (tests, result)
    assert (result:summary () == '7 run, 0 failed.')

end

local result = unittest.run (tests)
print (result:summary ())
