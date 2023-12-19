
local unittest = require 'unittest'

local traits = {
    
    setup = function (recv) recv.test = unittest.wasrun 'test_method' end,

    test_running = function (recv)
        local test = recv.test
        assert (not test.wasrun)
        test:run ()
        assert (test.wasrun)
    end,

    test_setup = function (recv)
        local test = recv.test
        test:run ()
        assert (test.wassetup)
    end,

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

case "test_running":run ()
case "test_setup":run ()