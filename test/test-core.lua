
local unittest = require 'unittest'

local t = {}

function t:setup ()
    self.test = unittest.bootstrap.wasrun ()
end

function t:test_templatemethod ()
    local wr = self.test
    wr:run {}
    assert (wr:logstring () == 'setup test_method teardown')
end

function t:test_result ()
    local wr = self.test
    local result = wr:run {}
    assert (tostring (result) == '1 ran, 0 failed.')
end

function t:test_failed ()
    local wr = unittest.bootstrap.wasrun_failing 'error_msg'
    local result = wr:run {}
    assert (tostring (result) == [[
1 ran, 1 failed.
test_method_failing: /usr/local/share/lua/5.4/unittest.lua:49: error_msg]])
end

function t:test_failed_result_formatting ()
    local result = unittest.bootstrap.result ()
    result:started ()
    result:failed ('dummy', 'no reason')
    assert (tostring (result) == [[
1 ran, 1 failed.
dummy: no reason]])
end

print(unittest.bootstrap.case 'test_templatemethod':run (t))
print(unittest.bootstrap.case 'test_result':run (t))
print(unittest.bootstrap.case 'test_failed_result_formatting':run (t))
print(unittest.bootstrap.case 'test_failed':run (t))

