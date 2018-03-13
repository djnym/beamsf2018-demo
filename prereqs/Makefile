ERL_VERSION=18.3.4.7
ERL_RELEASE=TEST1
ERL_UPSTREAM=git@github.com:erlang/otp.git

REBAR_VERSION=2.6.4
REBAR_RELEASE=TEST1
REBAR_UPSTREAM=git@github.com:rebar/rebar.git

REBAR3_VERSION=3.5.0
REBAR3_RELEASE=TEST1
REBAR3_UPSTREAM=git@github.com:erlang/rebar3.git

prereqs: erlang install-erlang rebar install-rebar rebar3 install-rebar3

erlang:
	@rpmbuild --define="ver $(ERL_VERSION)" \
	          --define="rel $(ERL_RELEASE)" \
		      --define="repo $(ERL_UPSTREAM)" \
		      --define="__debug_package 1" \
		      --define="_topdir `pwd`/rpmbuild" \
		      --define="_tmppath `pwd`/rpmbuild/tmp" \
		      -ba erlang.spec

install-erlang:
	sudo rpm -ivh rpmbuild/RPMS/x86_64/erlang-18.3.4.7-TEST1.x86_64.rpm

rebar:
	@rpmbuild --define="ver $(REBAR_VERSION)" \
	          --define="rel $(REBAR_RELEASE)" \
		      --define="repo $(REBAR_UPSTREAM)" \
		      --define="_topdir `pwd`/rpmbuild" \
		      --define="_tmppath `pwd`/rpmbuild/tmp" \
		      -ba rebar.spec

install-rebar:
	sudo rpm -ivh rpmbuild/RPMS/x86_64/rebar-2.6.4-TEST1.x86_64.rpm

rebar3:
	@rpmbuild --define="ver $(REBAR3_VERSION)" \
	          --define="rel $(REBAR3_RELEASE)" \
		      --define="repo $(REBAR3_UPSTREAM)" \
		      --define="_topdir `pwd`/rpmbuild" \
		      --define="_tmppath `pwd`/rpmbuild/tmp" \
		      -ba rebar3.spec

install-rebar3:
	sudo rpm -ivh rpmbuild/RPMS/x86_64/rebar3-3.5.0-TEST1.x86_64.rpm

# 'maintainer-clean' will remove the entire rpmbuild directory
maintainer-clean:
	rm -rf rpmbuild

# 'clean' will remove all but the rpms in the rpmbuild directory
clean:
	for d in BUILD BUILDROOT SOURCES SPECS tmp ; do \
	  test -d rpmbuild/$$d && rm -rf rpmbuild/$$d/* ; \
	done
