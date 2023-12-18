
local unittest = {}

unittest.traits = {

    testcase = {
        run = function (recv) return recv[recv.name] () end
    }

}

function unittest.test_case (name) 

    local t = {}

    setmetatable (t, {

        __index = function (recv, key) return unittest.traits.testcase[key] end

    })

    t.name = name

    return t

end

function unittest.wasrun (name)
    
    local t = unittest.test_case (name)

    t.wasrun = false
    
    t.test_method = function () t.wasrun = true end
    
    return t
end

return unittest