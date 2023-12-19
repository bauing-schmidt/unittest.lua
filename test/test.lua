
local unittest = require 'unittest'

do
    local case = unittest.case "test_running"

    function case.test_running ()
        local test = unittest.wasrun 'test_method'

        assert (not test.wasrun, 'before')
        test:run ()
        assert (test.wasrun, 'after')
    end    

    case:run()
end

do
    local case = unittest.case "test_setup"

    function case.test_setup ()
        local test = unittest.wasrun 'test_method'

        test:run ()
        assert (test.wassetup)
    end    

    case:run()
end

