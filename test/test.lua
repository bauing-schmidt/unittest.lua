
local unittest = require 'unittest'

local traits = {
    
    test_template_method = function (recv)
        local test = unittest.wasrun 'test_method'
        test:run ()
        assert (test:logstring () == 'setup test_method teardown')
    end,

    test_result = function (recv)

        local test = unittest.wasrun 'test_method'
        local result = test:run ()
        assert ('1 run, 0 failed.' == result:summary ())

    end,

    test_failed_result = function (recv)

        local test = unittest.wasrun 'test_broken_method'
        local result = test:run ()
        assert ('1 run, 1 failed.' == result:summary ())

    end,

    test_failedresultformatting = function (recv)

        local result = unittest.new_result ()
        result:started ()
        result:failed ()
        assert (result:summary () == '1 run, 1 failed.')

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

case "test_template_method":run ()
case "test_result":run ()
case "test_failed_result":run ()
case "test_failedresultformatting":run ()
