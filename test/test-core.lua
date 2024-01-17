
local unittest = require 'unittest'

local t = {}

function t:setup ()
    self.test = unittest.bootstrap.wasrun ()
end

function t:test_running ()
    local wr = self.test

    assert (not wr.wasrun)
    wr:run {}
    assert (wr.wasrun)
end

function t:test_setup ()
    local wr = self.test

    assert (not wr.wassetup)
    wr:run {}
    assert (wr.wassetup)
end

unittest.bootstrap.case 'test_running':run (t)
unittest.bootstrap.case 'test_setup':run (t)