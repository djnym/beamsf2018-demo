%define name rebar3
%define upstream %{repo}

Name:       %{name}
Version:    %{ver}
Release:    %{rel}
Summary:    Erlang build tool that makes it easy to compile and test Erlang applications and releases.

Group:      Development/Libraries
License:    Apache-2.0
URL:        http://www.rebar3.org/
BuildRoot:  %{_tmppath}/%{name}-%{version}

Packager: Anthony Molinaro <anthonym@alumi.caltech.edu>

Provides: rebar = %{version}

%description
Rebar3 is an Erlang tool that makes it easy to create, develop, and release Erlang libraries, applications, and systems in a repeatable manner.

%prep
if [ ! -d %{name} ] ; then
  git clone %{repo} %{name}
fi
cd %{name}
git checkout master
git pull
git checkout %{ver}

%build
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT
cd %{name}
./bootstrap

%install
rm -rf $RPM_BUILD_ROOT
cd %{name}
mkdir -p $RPM_BUILD_ROOT/usr/bin/
cp rebar3 $RPM_BUILD_ROOT/usr/bin/

%clean
rm -rf $RPM_BUILD_ROOT
rm -rf $RPM_BUILD_DIR/%{name}-%{version}

%files
%defattr(-,root,root,0755)
%{_bindir}/*

%changelog
* Mon Mar 12 2018 Anthony Molinaro <anthonym@alumni.caltech.edu>
- generalized to build from upstream source
