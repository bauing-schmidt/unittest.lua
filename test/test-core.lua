
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
    local wr = unittest.bootstrap.wasrun_failing ()
    local result = wr:run {}
    assert (tostring (result) == '1 ran, 1 failed.')
end

function t:test_failed_result_formatting ()
    local result = unittest.bootstrap.result ()
    result:started ()
    result:failed ()
    assert (tostring (result) == '1 ran, 1 failed.')
end

unittest.bootstrap.case 'test_templatemethod':run (t)
unittest.bootstrap.case 'test_result':run (t)
unittest.bootstrap.case 'test_failed_result_formatting':run (t)
unittest.bootstrap.case 'test_failed':run (t)

