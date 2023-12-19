
local unittest = {}

unittest.traits = {

    testcase = {
        run = function (recv) 
            recv:setup ()
            return recv[recv.name] (recv) 
        end,
        setup = function (recv) end,
    }

}

function unittest.case (name) 

    local t = {}

    setmetatable (t, {

        __index = function (recv, key) return unittest.traits.testcase[key] end

    })

    t.name = name

    return t

end

function unittest.wasrun (name)
    
    local t = unittest.case (name)

    function t.test_method (recv) recv.wasrun = true end

    function t.setup (recv)
        recv.wasrun = false
        recv.wassetup = true 
    end

    return t
end

return unittest