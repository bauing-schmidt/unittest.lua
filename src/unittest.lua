
local unittest = {
    metatables = {
        wasrun = {},
        case = {},
        result = {}
    },
    traits = {
        wasrun = {},
        case = {},
        result = {},
    },
    bootstrap = {}
}

setmetatable (unittest.traits.wasrun, {
    __index = unittest.traits.case
})

function unittest.traits.result:started ()
    self.runcount = self.runcount + 1
end

function unittest.traits.result:failed (name, error_msg)
    self.failedcount = self.failedcount + 1
    self.failure[name] = error_msg
end

function unittest.traits.wasrun:logstring ()
    return table.concat (self.log, ' ')
end

function unittest.traits.case:run (client)
    local r = unittest.bootstrap.result ()
    r:started ()
    if client.setup then client:setup () end    
    local ok, error_msg = pcall(client[self.name], client)
    if not ok then r:failed (self.name, error_msg) end
    if client.teardown then client:teardown () end
    return r
end

function unittest.traits.wasrun:run (client)
    function client.test_method (recv) table.insert (self.log, 'test_method') end
    function client.setup (recv) table.insert (self.log, 'setup') end
    function client.teardown (recv) table.insert (self.log, 'teardown') end
    function client.test_method_failing (recv) 
        table.insert (self.log, 'test_method_failing')
        error (self.error_msg)
    end
    return getmetatable (unittest.traits.wasrun).__index.run (self, client)
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

    local t = { runcount = 0, failedcount = 0, failure = {} }

    setmetatable (t, unittest.metatables.result)

    return t

end

return unittest