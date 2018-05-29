BASEDIR = $(shell pwd)
RELPATH = _build/default/rel/tanodb
APPNAME = storix
SHELL = /bin/bash

release:
	mix release

compile:
	mix compile

clean:
	mix clean

devrel1:
	MIX_ENV=dev1 mix release 

devrel2:
	MIX_ENV=dev2 mix release

devrel3:
	MIX_ENV=dev3 mix release

devrel: devrel1 devrel2 devrel3

dev-attach1:
	$(BASEDIR)/_build/dev1/rel/$(APPNAME)/bin/$(APPNAME) attach

dev-attach2:
	$(BASEDIR)/_build/dev2/rel/$(APPNAME)/bin/$(APPNAME) attach

dev-attach3:
	$(BASEDIR)/_build/dev3/rel/$(APPNAME)/bin/$(APPNAME) attach

dev-console1:
	$(BASEDIR)/_build/dev1/rel/$(APPNAME)/bin/$(APPNAME) console

dev-console2:
	$(BASEDIR)/_build/dev2/rel/$(APPNAME)/bin/$(APPNAME) console

dev-console3:
	$(BASEDIR)/_build/dev3/rel/$(APPNAME)/bin/$(APPNAME) console

devrel-start:
	for d in $(BASEDIR)/_build/dev{1,2,3}; do $$d/rel/$(APPNAME)/bin/$(APPNAME) start; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do $$d/rel/$(APPNAME)/bin/$(APPNAME)-admin cluster join dev1@127.0.0.1; done

devrel-cluster-plan:
	$(BASEDIR)/_build/dev1/rel/$(APPNAME)/bin/$(APPNAME)-admin cluster plan

devrel-cluster-commit:
	$(BASEDIR)/_build/dev1/rel/$(APPNAME)/bin/$(APPNAME)-admin cluster commit

devrel-status:
	$(BASEDIR)/_build/dev1/rel/$(APPNAME)/bin/$(APPNAME)-admin member-status

devrel-ping:
	for d in $(BASEDIR)/_build/dev{1,2,3}; do $$d/rel/$(APPNAME)/bin/$(APPNAME) ping; true; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev{1,2,3}; do $$d/rel/$(APPNAME)/bin/$(APPNAME) stop; true; done

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

console:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) console

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

