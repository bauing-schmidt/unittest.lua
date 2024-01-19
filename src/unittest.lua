
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
    -- Checks if the specified name has been seen once.
    -- @param name The name to check.
    -- @return True if the name has been seen once, false otherwise.

    if not self.seen[name] then self.seen[name] = 0 end
    self.seen[name] = self.seen[name] + 1
    return self.seen[name] == 1
end

function unittest.traits.result:failed (name, error_msg)
    self.failure[name] = error_msg
end

function unittest.traits.result:failedcount ()
    local failedcount = 0
    for k, v in pairs (self.failure) do failedcount = failedcount + 1 end
    return failedcount
end

function unittest.traits.result:runcount ()
    local runcount = 0
    for k, v in pairs (self.seen) do runcount = runcount + 1 end
    return runcount
end

function unittest.traits.wasrun:logstring ()
    return table.concat (self.log, ' ')
end

function unittest.traits.case:run (client, result)
    if result:started (self.name) then
        if client.setup then client:setup (self) end    
        local ok, error_msg = pcall(client[self.name], client, self, result)
        if not ok then result:failed (self.name, error_msg) end
        if client.teardown then client:teardown (self) end
    end
end

function unittest.traits.suite:insert (case) table.insert (self.cases, case) end

function unittest.traits.suite:run (client, result)
    for i, case in pairs (self.cases) do case:run (client, result) end
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
    local fc = self:failedcount ()
    if fc > 0 then sep = '\n' end
    return string.format ('%d ran, %d failed.%s%s', self:runcount(), fc, sep, table.concat (failure, '\n'))
end

function unittest.bootstrap.wasrun (name)

    local t = unittest.bootstrap.case (name or 'test_method')

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

    local t = { failure = {}, seen = {} }

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

function unittest.bootstrap.file (filename)

    local tbl = dofile (filename)

    return unittest.bootstrap.suite (tbl), tbl
end

unittest.assert = {}

local eq_functions = {}

function eq_functions.same (a, b) return a == b end

function eq_functions.equals (a, b)
    local atype = type(a)
    if 'table' == atype and atype == type(b) then return eq_functions.eq_tbls (a, b)
    else return eq_functions.same (a, b) end
end

function eq_functions.eq_tbls (r, s)

    local used = {}

    for k, v in pairs (r) do

        local missing = true

        for kk, vv in pairs (s) do

            if (not used[kk]) and eq_functions.equals (k, kk) then 

                if eq_functions.equals (v, vv) then missing = false; used[kk] = true end

            end

        end

        if missing then return false end

    end

    for k, v in pairs (s) do if not used[k] then return false end end

    return true

end

local function tostring_recursive(t, indent_orig)
    indent_orig = indent_orig or ''
    local indent = indent_orig or ''
    local chunks = {}
    
    if type(t) ~= 'table' then t = {t} 
    else 
        table.insert (chunks, indent .. '{') 
        indent = indent .. '  '
    end
    
    for k, v in pairs(t) do
        local chunk
        if type(v) == 'table' then
            chunk = indent .. k .. ':\n' .. tostring_recursive(v, indent .. '  ')
        elseif type(v) == 'string' then
            chunk = indent .. k .. ": '" .. tostring(v) .. "'"
        else 
            chunk = indent .. k .. ': ' .. tostring(v)
        end
        table.insert (chunks, chunk)
    end
    if chunks[1] == '{' then table.insert (chunks, indent_orig .. '}') end
    return table.concat (chunks, '\n')
end

function unittest.assert.same (a)
    return function (b)
        return assert (eq_functions.same (a, b), string.format([[
Expected:
%s
Actual:
%s]], tostring_recursive(b), tostring_recursive(a))) 
    end
end

function unittest.assert.equals (...)
    local b = table.pack (...)
    return function (...) 
        local a = table.pack (...) 
        if not eq_functions.eq_tbls (a, b) then
            error (string.format([[

Expected:
%s
Actual:
%s]], tostring_recursive(b), tostring_recursive(a)), 2)
        end
        return true
    end
end

unittest.assert.istrue = unittest.assert.equals (true)
unittest.assert.isfalse = unittest.assert.equals (false)

unittest.deny = {}

function unittest.deny.same (a)
    return function (b)
        return assert (not eq_functions.same (a, b), string.format([[
Expected:
%s
Actual:
%s]], tostring_recursive(b), tostring_recursive(a))) 
    end
end

function unittest.deny.equals (...) 
    local b = table.pack (...)
    return function (...) 
        local a = table.pack (...) 
        return assert (not eq_functions.eq_tbls (a, b),  string.format([[
Expected:
%s
Actual:
%s]], tostring_recursive(b), tostring_recursive(a))) 
    end
end

return unittest