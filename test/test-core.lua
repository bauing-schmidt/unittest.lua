
local unittest = require 'unittest'

local T = {
    setup = function (self, runner) table.insert (runner.log, 'setup') end,
    test_method = function (self, runner) table.insert (runner.log, 'test_method') end,
    teardown = function (self, runner) table.insert (runner.log, 'teardown') end,
    test_method_failing = function (self, runner) 
        table.insert (runner.log, 'test_method')
        error ('error_msg', 0) -- 0: no stack trace
    end,
}

local C = {}

local function count_tests (tbl)
    local count = 0
    for k, v in pairs (tbl) do if string.sub(k, 1, 4) == 'test' then count = count + 1 end end
    return count
end

local function result_header (result_str)
    local i = string.find (result_str, '\n', 1, true) or (#result_str + 1)
    return string.sub (result_str, 1, i - 1)
end

function C.setup (self) self.result = unittest.bootstrap.result () end

function C.test_running (self)
    
    local runner = unittest.bootstrap.wasrun 'test_method'

    runner:run (T, self.result)

    assert (runner:logstring () == 'setup test_method teardown', 'wrong sequence of calls')   
    
    self.result:beverbose ()
    assert (tostring (self.result) == '1 ran, 0 failed.\n✔ test_method', 'wrong result string')
end

function C.test_failing (self)
    local runner = unittest.bootstrap.wasrun 'test_method_failing'
    runner:run (T, self.result)
    assert (tostring (self.result) == [[
1 ran, 1 failed.
✗ test_method_failing: error_msg]])
end

function C.test_failed_result_formatting (self)
    local started = self.result:started ('dummy')
    self.result:failed ('dummy', 'no reason')
    assert (started)
    assert (tostring (self.result) == [[
1 ran, 1 failed.
✗ dummy: no reason]])
end

function C.test_suite (self)
    local result = unittest.bootstrap.result ()
    local suite = unittest.bootstrap.suite ()
    suite:insert (unittest.bootstrap.case 'test_running')
    suite:insert (unittest.bootstrap.case 'test_failing')
    suite:run (C, result)
    assert (result_header(tostring (result)) == '2 ran, 0 failed.')
end

function C.test_api_suite (self)
    local S = {
        setup = C.setup, -- necessary to initialize the result object
        test_running = C.test_running,
        test_failing = C.test_failing,
    }
    local result = unittest.api.suite (S)
    assert (result_header(tostring (result)) == '2 ran, 0 failed.')
end

function C.test_suite_automatic_discovery (self, runner, result)
    local suite = unittest.bootstrap.suite (C)
    suite:run (C, result)    
    assert (result_header(tostring (result)) == string.format('%d ran, 0 failed.', count_tests (C)))
end


function C.test_file_assert (self)
    local filename = 'test/test-assert.lua'
    local suite, A = unittest.bootstrap.file (filename)
    suite:run (A, self.result)
    assert (result_header(tostring (self.result)) == string.format('%d ran, 0 failed.', count_tests (A)))
    print (filename .. ':\t\t' .. tostring (self.result))
end


function C.test_file_learning (self)
    local filename = 'test/test-learning.lua'
    local suite, A = unittest.bootstrap.file (filename)
    suite:run (A, self.result)
    -- assert (result_header(tostring (self.result)) == string.format('%d ran, 0 failed.', count_tests (A)))
    print (filename .. ':\t\t' .. tostring (self.result))
end

function C.test_file_dummy (self)
    local filename = 'test/test-dummy.lua'
    local suite, A = unittest.bootstrap.file (filename)
    suite:run (A, self.result)
    self.result:beverbose ()
    assert (tostring (self.result) == '1 ran, 0 failed.\n✔ test_dummy')
    print (filename .. ':\t\t' .. tostring (self.result))
end

local result = unittest.api.suite (C)

-- unittest.assert.equals 'Expected all successes.'
--     (string.format('%d ran, 0 failed.', count_tests (C)))
--     (result_header (tostring (result)))

print ('test/test-core.lua:\t\t' .. tostring (result))



