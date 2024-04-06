.PHONY: default test

define runtest
	$(eval LUA_EXECUTABLE = $(1))
  @echo "testing on $(LUA_EXECUTABLE)"
  @busted --lua="/usr/bin/$(LUA_EXECUTABLE)"
  @echo
endef

default: test

test:
	@echo
	$(call runtest,luajit)
	$(call runtest,lua5.1)
	$(call runtest,lua5.2)
	$(call runtest,lua5.3)
	$(call runtest,lua5.4)
