
local unittest = {
    metatables = {
        wasrun = {},
        case = {}
    },
    traits = {
        wasrun = {},
        case = {}
    },
    bootstrap = {}
}

setmetatable (unittest.traits.wasrun, {
    __index = unittest.traits.case
})

function unittest.traits.wasrun:logstring ()
    return table.concat (self.log, ' ')
end

function unittest.traits.case:run (client)
    if client.setup then client:setup () end    
    client[self.name] (client)
    if client.teardown then client:teardown () end   
end

function unittest.traits.wasrun:run (client)
    function client.test_method (recv) table.insert (self.log, 'test_method') end
    function client.setup (recv) table.insert (self.log, 'setup') end
    function client.teardown (recv) table.insert (self.log, 'teardown') end
    getmetatable (unittest.traits.wasrun).__index.run (self, client)
end

function unittest.metatables.wasrun:__index (key)
    return unittest.traits.wasrun[key]
end

function unittest.metatables.case:__index (key)
    return unittest.traits.case[key]
end

function unittest.bootstrap.wasrun ()

    local t = unittest.bootstrap.case 'test_method'

    t.log = {}

    setmetatable (t, unittest.metatables.wasrun)

    return t

end

function unittest.bootstrap.case (name)

    local t = { name = name }

    setmetatable (t, unittest.metatables.case)

    return t

end


return unittest