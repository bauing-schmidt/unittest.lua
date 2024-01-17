
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

function unittest.traits.wasrun:test_method ()
    self.wasrun = true
end

function unittest.traits.case:run (...)
    self[self.name] (self, ...)
end

function unittest.metatables.wasrun:__index (key)
    return unittest.traits.wasrun[key] or unittest.traits.case[key]
end

function unittest.metatables.case:__index (key)
    return unittest.traits.case[key]
end

function unittest.bootstrap.wasrun (name)

    local t = unittest.bootstrap.case (name, true)

    t.wasrun = false

    setmetatable (t, unittest.metatables.wasrun)

    return t

end

function unittest.bootstrap.case (name, mt)

    local t = { name = name }

    if not mt then setmetatable (t, unittest.metatables.case) end

    return t

end


return unittest