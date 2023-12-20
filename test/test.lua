
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
        assert ('1 run, 1 failed.' == result:summary ())

    end,

    test_failedresultformatting = function (recv)

        local result = unittest.new_result ()
        result:started ()
        result:failed ()
        assert (result:summary () == '1 run, 1 failed.')

    end,

    test_cases = function (recv)

        local cases = unittest.cases ()
        cases:append (unittest.wasrun 'test_method')
        cases:append (unittest.wasrun 'test_broken_method')
        local result = unittest.new_result ()
        cases:run (result)
        assert (result:summary () == '2 run, 1 failed.')

    end

}

local function case (name)
    local c = unittest.case (name)

    local __index = getmetatable (c).__index

    setmetatable (c, {

        __index = function (recv, key) 
            return traits[key] or __index (recv, key) 
        end

    })

    return c
end

local cases = unittest.cases ()
cases:append (case "test_template_method")
cases:append (case "test_result")
cases:append (case "test_failed_result")
cases:append (case "test_failedresultformatting")
cases:append (case "test_cases")
local result = unittest.new_result ()
cases:run (result)
print (result:summary ())

