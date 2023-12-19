
local unittest = {}

unittest.traits = {

    testcase = {
        run = function (recv)
            local result = unittest.new_result ()
            
            result:started ()

            recv:setup ()

            local succeed = pcall (recv[recv.name], recv)

            if not succeed then result:failed () end
            
            recv:teardown ()
            
            return result
        end,
        setup = function (recv) end,
        teardown = function (recv) end,
    },

    testresult = {

        summary = function (recv)
            return string.format ('%d run, %d failed.', recv.runcount, recv.failedcount)
        end,

        started = function (recv) recv.runcount = recv.runcount + 1 end,

        failed = function (recv) recv.failedcount = recv.failedcount + 1 end

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

    t.log = {}

    function t.test_method (recv) 
        table.insert (recv.log, 'test_method')
    end

    function t.test_broken_method (recv) 
        error ()
    end

    function t.logstring (recv) return table.concat (recv.log, ' ') end

    function t.setup (recv)
        table.insert (recv.log, 'setup')
    end

    function t.teardown (recv)
        table.insert (recv.log, 'teardown')
    end

    return t
end

function unittest.new_result ()
    local o = { runcount = 0, failedcount = 0 }

    setmetatable(o, {
        __index = function (recv, key) return unittest.traits.testresult[key] end
    })

    return o
end


return unittest