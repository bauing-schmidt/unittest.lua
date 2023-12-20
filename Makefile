
install:
	cp src/unittest.lua /usr/local/share/lua/5.4/

test:
	lua test/test-core.lua
	lua test/test-assert.lua