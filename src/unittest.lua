
local unittest = {
    metatables = {
        wasrun = {},
        case = {},
        result = {},
        suite = {},
    },
    traits = {
        wasrun = {},
        case = {},
        result = {},
        suite = {},
    },
    bootstrap = {}
}

setmetatable (unittest.traits.wasrun, {
    __index = unittest.traits.case
})

function unittest.traits.result:started (name)
    if not self.seen[name] then
        self.seen[name] = true
        self.runcount = self.runcount + 1
        return true
    else return false end    
end

function unittest.traits.result:failed (name, error_msg)
    self.failedcount = self.failedcount + 1
    self.failure[name] = error_msg
end

function unittest.traits.wasrun:logstring ()
    return table.concat (self.log, ' ')
end

function unittest.traits.case:run (client, result)
    if result:started (self.name) then
        if client.setup then client:setup () end    
        local ok, error_msg = pcall(client[self.name], client, result)
        if not ok then result:failed (self.name, error_msg) end
        if client.teardown then client:teardown () end
    end
    return result
end

function unittest.traits.wasrun:run (client, result)
    function client.test_method (recv) table.insert (self.log, 'test_method') end
    function client.setup (recv) table.insert (self.log, 'setup') end
    function client.teardown (recv) table.insert (self.log, 'teardown') end
    function client.test_method_failing (recv) 
        table.insert (self.log, 'test_method_failing')
        error (self.error_msg)
    end
    return getmetatable (unittest.traits.wasrun).__index.run (self, client, result)
end

function unittest.traits.suite:insert (case) table.insert (self.cases, case) end

function unittest.traits.suite:run (client, result)
    for i, case in pairs (self.cases) do case:run (client, result) end
    return result
end

function unittest.metatables.wasrun:__index (key)
    return unittest.traits.wasrun[key]
end

function unittest.metatables.case:__index (key)
    return unittest.traits.case[key]
end

function unittest.metatables.result:__index (key)
    return unittest.traits.result[key]
end

function unittest.metatables.suite:__index (key)
    return unittest.traits.suite[key]
end

function unittest.metatables.result:__tostring ()
    local failure = {}
    for k, v in pairs (self.failure) do table.insert (failure, string.format ('%s: %s', k, v)) end
    local sep = ''
    if self.failedcount > 0 then sep = '\n' end
    return string.format ('%d ran, %d failed.%s%s', 
                          self.runcount, self.failedcount, sep, table.concat (failure, '\n'))
end

function unittest.bootstrap.wasrun ()

    local t = unittest.bootstrap.case 'test_method'

    t.log = {}

    setmetatable (t, unittest.metatables.wasrun)

    return t

end


function unittest.bootstrap.wasrun_failing (error_msg)

    local t = unittest.bootstrap.case 'test_method_failing'

    t.log = {}
    t.error_msg = error_msg

    setmetatable (t, unittest.metatables.wasrun)

    return t

end

function unittest.bootstrap.case (name)

    local t = { name = name }

    setmetatable (t, unittest.metatables.case)

    return t

end

function unittest.bootstrap.result ()

    local t = { runcount = 0, failedcount = 0, failure = {}, seen = {} }

    setmetatable (t, unittest.metatables.result)

    return t

end

function unittest.bootstrap.suite (tbl)

    local t = { cases = {} }

    setmetatable (t, unittest.metatables.suite)

    for name, c in pairs (tbl or {}) do 
        if string.sub (name, 1, 4) == 'test' then
            t:insert (unittest.bootstrap.case (name))
        end
    end

    return t

end

function unittest.suite (tbl)
    local suite = unittest.bootstrap.suite (tbl)
    return suite:run (tbl, unittest.bootstrap.result ())
end

return unittest