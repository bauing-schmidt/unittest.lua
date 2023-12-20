
local unittest = require 'unittest'

local traits = {
    
    test_template_method = function (recv)
        local test = unittest.wasrun 'test_method'
        test:run (unittest.new_result ())
        assert (test:logstring () == 'setup test_method teardown')
    end,

    test_result = function (recv)

        local test = unittest.wasrun 'test_method'
        local result = unittest.new_result ()
        test:run (result)
        assert ('1 run, 0 failed.' == result:summary ())

    end,

    test_failed_result = function (recv)

        local test = unittest.wasrun 'test_broken_method'
        local result = unittest.new_result ()
        test:run (result)
        
        assert (result:summary () == [[
1 run, 1 failed.
test_broken_method: /usr/local/share/lua/5.4/unittest.lua:85: explicitly raised.]])

    end,

    test_failedresultformatting = function (recv)

        local result = unittest.new_result ()
        local not_seen = result:started (recv)
        result:failed ({name = 'test_dummy'}, 'no reason.')
        
        assert (not_seen)
        assert (result:summary () == [[
1 run, 1 failed.
test_dummy: no reason.]])

    end,

    test_cases = function (recv)

        local cases = unittest.cases ()
        cases:append (unittest.wasrun 'test_method')
        cases:append (unittest.wasrun 'test_broken_method')
        local result = unittest.new_result ()
        cases:run (result)

        assert (result:summary () == [[
2 run, 1 failed.
test_broken_method: /usr/local/share/lua/5.4/unittest.lua:85: explicitly raised.]])

    end,

}

function traits.test_suite (recv, result)

    local suite = unittest.suite (traits)
    suite:run (result)
    assert (result:summary () == '6 run, 0 failed.')

end


local result = unittest.new_result ()
unittest.suite (traits):run (result)
print (result:summary ())
