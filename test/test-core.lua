
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


unittest.bootstrap.case 'test_templatemethod':run (t)