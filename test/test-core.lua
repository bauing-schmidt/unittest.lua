
local unittest = require 'unittest'

local t = {}

local function count (t)
    local c = 0
    for name, _ in pairs (t) do 
        if string.sub (name, 1, 4) == 'test' then c = c + 1 end
    end
    return c
end

function t:setup ()
    self.case = unittest.bootstrap.wasrun ()
    self.result = unittest.bootstrap.result ()
end

function t:test_templatemethod ()
    local wr = self.case
    wr:run ({}, self.result)
    assert (wr:logstring () == 'setup test_method teardown')
end

function t:test_result ()
    local wr = self.case
    local result = wr:run ({}, self.result)
    assert (tostring (result) == '1 ran, 0 failed.')
end

function t:test_failed ()
    local wr = unittest.bootstrap.wasrun_failing 'error_msg'
    local result = wr:run ({}, self.result)
    assert (tostring (result) == [[
1 ran, 1 failed.
test_method_failing: /usr/local/share/lua/5.4/unittest.lua:68: error_msg]])
end

function t:test_failed_result_formatting ()
    local result = self.result
    local started = result:started ('dummy')
    result:failed ('dummy', 'no reason')
    assert (started)
    assert (tostring (result) == [[
1 ran, 1 failed.
dummy: no reason]])
end

function t:test_suite ()
    local suite = unittest.bootstrap.suite ()
    suite:insert (unittest.bootstrap.case 'test_templatemethod')
    suite:insert (unittest.bootstrap.case 'test_failed')
    local result = suite:run (t, self.result)
    assert (tostring (result) == '2 ran, 0 failed.')
end

function t:test_suite_automatically_discovered (result)
    unittest.bootstrap.suite (t):run (t, result)
    assert (tostring (result) == string.format('%d ran, 0 failed.', count (t)))
end

function t:test_suite_file_dummy ()
    local filename = 'test/test-dummy.lua'
    local tests = dofile (filename)
    unittest.bootstrap.suite (tests):run (tests, self.result)
    assert (tostring (self.result) == '1 ran, 0 failed.')
    print (filename .. ': \t\t' .. tostring(self.result))
end

function t:test_suite_file_assert ()
    local filename = 'test/test-assert.lua'
    local tests = dofile (filename)
    unittest.bootstrap.suite (tests):run (tests, self.result)
    -- assert (tostring (self.result) == string.format('%d ran, 0 failed.', count (tests)))
    print (filename .. ': \t\t' .. tostring(self.result))
end

function t:test_suite_file_learning ()
    local filename = 'test/test-learning.lua'
    local tests = dofile (filename)
    unittest.bootstrap.suite (tests):run (tests, self.result)
    -- assert (tostring (self.result) == string.format('%d ran, 0 failed.', count (tests)))
    print (filename .. ': \t' .. tostring(self.result))
end

local result = unittest.suite (t)
print ('test/test-core: \t\t' .. tostring(result))
assert (tostring (result) == string.format('%d ran, 0 failed.', count (t)))
