##
## Erlang and Rebar versions and repos
##
ERL_VERSION=18.3.4.7
ERL_RELEASE=TEST1
ERL_UPSTREAM=git@github.com:erlang/otp.git
REBAR_VERSION=2.6.4
REBAR_RELEASE=TEST1
REBAR_UPSTREAM=git@github.com:rebar/rebar.git
REBAR3_VERSION=3.5.0
REBAR3_RELEASE=TEST1
REBAR3_UPSTREAM=git@github.com:erlang/rebar3.git

##
## Framewerk Packages Versions
##
FW_VERSION=0.9.8
FWTER_VERSION=0.5.0
ERLRC_VERSION=1.1.2
ERLSTART_VERSION=0.0.7
GOLDRUSH_VERSION=0.1.6
LAGER_VERSION=2.1.1
SYSLOG_VERSION=1.0.3
LAGER_SYSLOG_VERSION=2.1.2
CECHO_VERSION=0.4.1
ENTOP_VERSION=0.2.0
RECON_VERSION=2.3.1
ERLNODE_VERSION=0.7.1
COWLIB_VERSION=1.0.2
RANCH_VERSION=1.3.2
COWBOY_VERSION=1.1.2

FW_POST_RELEASE_COMMANDS="echo"

prereqs: erlang rebar rebar3

erlang:
	@rpm -q erlang-$(ERL_VERSION)-$(ERL_RELEASE) \
	  2>&1 > /dev/null || \
	 ( cd prereqs ; \
	   rpmbuild --define="ver $(ERL_VERSION)" \
	          --define="rel $(ERL_RELEASE)" \
		      --define="repo $(ERL_UPSTREAM)" \
		      --define="__debug_package 1" \
		      --define="_topdir `pwd`/rpmbuild" \
		      --define="_tmppath `pwd`/rpmbuild/tmp" \
		      -ba erlang.spec ; \
	    sudo rpm -i \
	      rpmbuild/RPMS/x86_64/erlang-$(ERL_VERSION)-$(ERL_RELEASE).x86_64.rpm \
	 )

rebar:
	@rpm -q rebar-$(REBAR_VERSION)-$(REBAR_RELEASE) \
	  2>&1 > /dev/null || \
	 ( cd prereqs ; \
	   rpmbuild --define="ver $(REBAR_VERSION)" \
	            --define="rel $(REBAR_RELEASE)" \
		        --define="repo $(REBAR_UPSTREAM)" \
		        --define="_topdir `pwd`/rpmbuild" \
		        --define="_tmppath `pwd`/rpmbuild/tmp" \
		        -ba rebar.spec ; \
	   sudo rpm -i \
	    rpmbuild/RPMS/x86_64/rebar-$(REBAR_VERSION)-$(REBAR_RELEASE).x86_64.rpm \
	 )

rebar3:
	@rpm -q rebar3-$(REBAR3_VERSION)-$(REBAR3_RELEASE) \
	  2>&1 > /dev/null || \
	 ( cd prereqs ; \
	   rpmbuild --define="ver $(REBAR3_VERSION)" \
	            --define="rel $(REBAR3_RELEASE)" \
		        --define="repo $(REBAR3_UPSTREAM)" \
		        --define="_topdir `pwd`/rpmbuild" \
		        --define="_tmppath `pwd`/rpmbuild/tmp" \
		        -ba rebar3.spec ; \
	   sudo rpm -i \
	     rpmbuild/RPMS/x86_64/rebar3-$(REBAR3_VERSION)-$(REBAR3_RELEASE).x86_64.rpm \
	 )

# 'maintainer-clean' will remove the entire rpmbuild directory
maintainer-clean:
	@rm -rf cowboy_example
	@rm -rf framewerk prereqs/rpmbuild

# 'clean' will remove all but the rpms in the rpmbuild directory
clean:
	for d in BUILD BUILDROOT SOURCES SPECS tmp ; do \
	  test -d prereqs/rpmbuild/$$d && rm -rf prereqs/rpmbuild/$$d/* ; \
	done

framewerk: setup fw fw-template-erlang-rebar

setup:
	@mkdir -p framewerk/{packages,project}

cowboy_example:
	@(rm -rf cowboy_example ; \
	  mkdir cowboy_example ; \
	  cd cowboy_example ; \
	  wget -q https://raw.githubusercontent.com/ninenines/cowboy/1.1.2/examples/hello_world/src/hello_world.app.src ; \
	  wget -q https://raw.githubusercontent.com/ninenines/cowboy/1.1.2/examples/hello_world/src/hello_world_app.erl ; \
	  wget -q https://raw.githubusercontent.com/ninenines/cowboy/1.1.2/examples/hello_world/src/hello_world_sup.erl ; \
	  wget -q https://raw.githubusercontent.com/ninenines/cowboy/1.1.2/examples/hello_world/src/toppage_handler.erl ; \
	  mv hello_world.app.src mywebapp.app.src ; \
	  mv hello_world_app.erl mywebapp_app.erl ; \
	  mv hello_world_sup.erl mywebapp_sup.erl ; \
	  sed -i 's/hello_world/mywebapp/g' * \
	)

fw: setup
	@rpm -q framewerk-$(FW_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	( cd framewerk/packages ; \
	  rm -rf fw ; \
	  git clone git@github.com:dukesoferl/fw.git ; \
	  cd fw ; \
	  git checkout "$(FW_VERSION)" ; \
	  ./bootstrap && ./configure && make package ; \
	  sudo rpm -i fw-pkgout/framewerk-$(FW_VERSION)-TEST1.noarch.rpm \
	)

fw-template-erlang-rebar: fw erlang rebar
	@rpm -q fw-template-erlang-rebar-$(FWTER_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	( cd framewerk/packages ; \
	  rm -rf fw-template-erlang-rebar ; \
	  git clone git@github.com:dukesoferl/fw-template-erlang-rebar.git ; \
	  cd fw-template-erlang-rebar ; \
	  git checkout $(FWTER_VERSION) ; \
	  ./bootstrap && ./configure && make package ; \
	  sudo rpm -i fw-pkgout/fw-template-erlang-rebar-$(FWTER_VERSION)-TEST1.noarch.rpm \
	)

erlrc: fw-template-erlang-rebar
	@rpm -q erlang-18-erlrc-$(ERLRC_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	( cd framewerk/packages ; \
	  rm -rf erlrc ; \
	  git clone git@github.com:dukesoferl/erlrc.git ; \
	  cd erlrc ; \
	  git checkout $(ERLRC_VERSION) ; \
	  ./bootstrap && ./configure && make package ; \
	  sudo rpm -i fw-pkgout/erlang-18-erlrc-$(ERLRC_VERSION)-TEST1.x86_64.rpm \
	)

erlstart: fw erlang
	@rpm -q erlang-18-erlstart-$(ERLSTART_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	( cd framewerk/packages ; \
	  rm -rf erlstart ; \
	  git clone git@github.com:dukesoferl/erlstart.git ; \
	  cd erlstart; \
	  git checkout $(ERLSTART_VERSION) ; \
	  ./bootstrap && ./configure && make package ; \
	  sudo rpm -i \
	    fw-pkgout/erlang-18-erlstart-$(ERLSTART_VERSION)-TEST1.noarch.rpm \
	)

goldrush: fw-template-erlang-rebar
	@rpm -q erlang-18-goldrush-$(GOLDRUSH_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	 ( cd framewerk/packages ; \
	   rm -rf goldrush ; \
	   fw-init --name goldrush \
	           --revision none \
			   --template erlang-rebar \
			   --with_build_prefix 1 \
			   --wrap_git_path git@github.com:DeadZen/goldrush.git \
			   --wrap_git_tag $(GOLDRUSH_VERSION) ; \
	   cd goldrush ; ./bootstrap && ./configure && make package ; \
	   sudo rpm -i \
	     fw-pkgout/erlang-18-goldrush-$(GOLDRUSH_VERSION)-TEST1.x86_64.rpm \
	 )

lager: fw-template-erlang-rebar goldrush
	@rpm -q erlang-18-lager-$(LAGER_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	 ( cd framewerk/packages ; \
	   rm -rf lager ; \
	   fw-init --name lager \
	           --revision none \
			   --template erlang-rebar \
			   --with_build_prefix 1 \
			   --wrap_git_path git@github.com:erlang-lager/lager.git \
			   --wrap_git_tag $(LAGER_VERSION) \
			   --with_deps goldrush ; \
	   cd lager ; ./bootstrap && ./configure && make package ; \
	   sudo rpm -i \
	     fw-pkgout/erlang-18-lager-$(LAGER_VERSION)-TEST1.x86_64.rpm \
	 )

syslog: fw-template-erlang-rebar
	@rpm -q erlang-18-syslog-$(SYSLOG_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	 ( cd framewerk/packages ; \
	   rm -rf syslog ; \
	   fw-init --name syslog --revision none --template erlang-rebar \
	           --with_build_prefix 1 \
			   --wrap_git_path git@github.com:Vagabond/erlang-syslog.git \
			   --wrap_git_tag $(SYSLOG_VERSION) ; \
	   cd syslog ; ./bootstrap && ./configure && make package ; \
	   sudo rpm -i \
	     fw-pkgout/erlang-18-syslog-$(SYSLOG_VERSION)-TEST1.x86_64.rpm \
	 )

lager_syslog: fw-template-erlang-rebar lager syslog
	@rpm -q erlang-18-lager_syslog-$(LAGER_SYSLOG_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	 ( cd framewerk/packages ; \
	   rm -rf lager_syslog ; \
	   fw-init --name lager_syslog --revision none --template erlang-rebar \
	           --with_build_prefix 1 \
		       --wrap_git_path git@github.com:basho/lager_syslog.git \
		       --wrap_git_tag $(LAGER_SYSLOG_VERSION) \
		       --with_deps "lager,syslog" ; \
	   cd lager_syslog ; ./bootstrap && ./configure && make package ; \
	   sudo rpm -i \
	     fw-pkgout/erlang-18-lager_syslog-$(LAGER_SYSLOG_VERSION)-TEST1.x86_64.rpm \
	 )

cecho: fw-template-erlang-rebar
	@rpm -q erlang-18-cecho-$(CECHO_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	 ( cd framewerk/packages ; \
	   rm -rf cecho; \
	   fw-init --name cecho --revision none --template erlang-rebar \
	           --with_build_prefix 1 \
			   --wrap_git_path git@github.com:djnym/cecho.git \
			   --wrap_git_tag $(CECHO_VERSION) ; \
	   cd cecho; \
	   echo 'enable_erlrc="no"' >> configure.ac.local ; \
	   ./bootstrap && ./configure && make package ; \
	   sudo rpm -i \
	     fw-pkgout/erlang-18-cecho-$(CECHO_VERSION)-TEST1.x86_64.rpm \
	 )

entop: fw-template-erlang-rebar cecho
	@rpm -q erlang-18-entop-$(ENTOP_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	 ( cd framewerk/packages ; \
	   rm -rf entop; \
	   fw-init --name entop --revision none --template erlang-rebar \
	           --with_build_prefix 1 \
			   --wrap_git_path git@github.com:mazenharake/entop.git \
			   --wrap_git_tag $(ENTOP_VERSION) \
			   --with_deps cecho ; \
	   cd entop ; \
	   echo 'enable_erlrc="no"' >> configure.ac.local ; \
	   ./bootstrap && ./configure && make package ; \
	   sudo rpm -i \
	     fw-pkgout/erlang-18-entop-$(ENTOP_VERSION)-TEST1.x86_64.rpm \
	 )

recon: fw-template-erlang-rebar
	@rpm -q erlang-18-recon-$(RECON_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	 ( cd framewerk/packages ; \
	   rm -rf recon; \
	   fw-init --name recon --revision none --template erlang-rebar \
	           --with_build_prefix 1 \
			   --wrap_git_path git@github.com:ferd/recon.git \
			   --wrap_git_tag $(RECON_VERSION) ; \
	   cd recon ; ./bootstrap && ./configure && make package ; \
	   sudo rpm -i fw-pkgout/erlang-18-recon-$(RECON_VERSION)-TEST1.x86_64.rpm \
	 )

erlnode: erlstart erlrc lager_syslog entop recon
	@rpm -q erlang-18-erlnode-$(ERLNODE_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	( cd framewerk/packages ; \
	  rm -rf erlnode ; \
	  git clone git@github.com:dukesoferl/erlnode.git ; \
	  cd erlnode; \
	  git checkout $(ERLNODE_VERSION) ; \
	  ./bootstrap && ./configure && make package ; \
	  sudo rpm -i \
	    fw-pkgout/erlang-18-erlnode-$(ERLNODE_VERSION)-TEST1.x86_64.rpm \
	)

cowlib: fw-template-erlang-rebar
	@rpm -q erlang-18-cowlib-$(COWLIB_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	( cd framewerk/packages ; \
	  rm -rf cowlib; \
	  fw-init --name cowlib \
	          --revision none \
			  --template erlang-rebar \
			  --with_build_prefix 1 \
			  --wrap_git_path git@github.com:ninenines/cowlib.git \
			  --wrap_git_tag $(COWLIB_VERSION) ; \
	  cd cowlib ; ./bootstrap && ./configure && make package ; \
	  sudo rpm -i \
	    fw-pkgout/erlang-18-cowlib-$(COWLIB_VERSION)-TEST1.x86_64.rpm \
	 )

ranch: fw-template-erlang-rebar
	@rpm -q erlang-18-ranch-$(RANCH_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	( cd framewerk/packages ; \
	  rm -rf ranch ; \
	  fw-init --name ranch \
	          --revision none \
			  --template erlang-rebar \
			  --with_build_prefix 1 \
			  --wrap_git_path git@github.com:ninenines/ranch.git \
			  --wrap_git_tag $(RANCH_VERSION) ; \
	  cd ranch ; ./bootstrap && ./configure && make package ; \
	  sudo rpm -i \
	    fw-pkgout/erlang-18-ranch-$(RANCH_VERSION)-TEST1.x86_64.rpm \
	 )

cowboy: fw-template-erlang-rebar cowlib ranch
	@rpm -q erlang-18-cowboy-$(COWBOY_VERSION)-TEST1 \
	  2>&1 > /dev/null || \
	( cd framewerk/packages ; \
	  rm -rf cowboy ; \
	  fw-init --name cowboy \
	          --revision none \
			  --template erlang-rebar \
			  --with_build_prefix 1 \
			  --wrap_git_path git@github.com:ninenines/cowboy.git \
			  --wrap_git_tag $(COWBOY_VERSION) \
			  --with_deps "cowlib,ranch" ; \
	  cd cowboy ; ./bootstrap && ./configure && make package ; \
	  sudo rpm -i \
	    fw-pkgout/erlang-18-cowboy-$(COWBOY_VERSION)-TEST1.x86_64.rpm \
	 )

fw-mywebapp: setup cowboy_example erlnode cowboy
	@rpm -q erlang-18-mywebapp \
	  2>&1 > /dev/null || \
	 ( cd framewerk/project ; \
	   rm -rf mywebapp ; \
	   fw-init --name mywebapp --revision none --template erlang-rebar \
	           --with_build_prefix 1 --with_deps cowboy ; \
	   cd mywebapp ; \
	   cp ../../../cowboy_example/* src ; \
	   ./bootstrap && ./configure && make package ; \
	   sudo rpm -ivh fw-pkgout/erlang-18-mywebapp-0.0.0-TEST1.x86_64.rpm \
	 )
