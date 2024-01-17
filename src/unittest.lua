
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

function unittest.traits.result:failed ()
    self.failedcount = self.failedcount + 1
end

function unittest.traits.wasrun:logstring ()
    return table.concat (self.log, ' ')
end

function unittest.traits.case:run (client)
    local r = unittest.bootstrap.result ()
    r:started ()
    if client.setup then client:setup () end    
    local ok = pcall(client[self.name], client)
    if not ok then r:failed () end
    if client.teardown then client:teardown () end
    return r
end

function unittest.traits.wasrun:run (client)
    function client.test_method (recv) table.insert (self.log, 'test_method') end
    function client.setup (recv) table.insert (self.log, 'setup') end
    function client.teardown (recv) table.insert (self.log, 'teardown') end
    function client.test_method_failing (recv) 
        table.insert (self.log, 'test_method_failing')
        error 'test_method_failing' 
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
    return string.format ('%d ran, %d failed.', self.runcount, self.failedcount)
end

function unittest.bootstrap.wasrun ()

    local t = unittest.bootstrap.case 'test_method'

    t.log = {}

    setmetatable (t, unittest.metatables.wasrun)

    return t

end


function unittest.bootstrap.wasrun_failing ()

    local t = unittest.bootstrap.case 'test_method_failing'

    t.log = {}

    setmetatable (t, unittest.metatables.wasrun)

    return t

end

function unittest.bootstrap.case (name)

    local t = { name = name }

    setmetatable (t, unittest.metatables.case)

    return t

end

function unittest.bootstrap.result ()

    local t = { runcount = 0, failedcount = 0 }

    setmetatable (t, unittest.metatables.result)

    return t

end

return unittest