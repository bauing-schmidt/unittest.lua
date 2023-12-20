
local unittest = {}

unittest.traits = {

    testcase = {
        run = function (recv, result)
                       
            result:started ()

            recv:setup ()

            local succeed = pcall (recv[recv.name], recv)   -- ignore returned values, just keep the succeed flag.

            if not succeed then result:failed () end
            
            recv:teardown ()
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

    },

    testcases = {

        append = function (recv, test) table.insert (recv.tests, test) end,
        run = function (recv, result) 
            for k, test in pairs (recv.tests) do
                test:run (result)
            end
        end

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

function unittest.cases ()

    local o = {
        tests = {}
    }

    setmetatable (o, {
        __index = function (recv, key) return unittest.traits.testcases[key] end
    })

    return o

end

local function eq_tbls (r, s)

    local used = {}

    for k, v in pairs (r) do

        local missing = true

        for kk, vv in pairs (s) do

            if (not used[kk]) and eq (k, kk) then 

                if eq (v, vv) then missing = false; used[kk] = true end

            end

        end

        if missing then return false end

    end

    for k, v in pairs (s) do if not used[k] then return false end end

    return true

end

return unittest