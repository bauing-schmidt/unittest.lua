
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

function unittest.traits.case:run (client)
    if client.setup then client:setup () end    
    client[self.name] (client)
end

function unittest.traits.wasrun:run (client)
    function client.test_method (recv) self.wasrun = true end
    function client.setup (recv) self.wassetup = true end
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

    t.wasrun = false
    t.wassetup = false

    setmetatable (t, unittest.metatables.wasrun)

    return t

end

function unittest.bootstrap.case (name)

    local t = { name = name }

    setmetatable (t, unittest.metatables.case)

    return t

end


return unittest