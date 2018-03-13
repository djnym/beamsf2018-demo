%define name rebar
%define upstream %{repo}

Name:       %{name}
Version:    %{ver}
Release:    %{rel}
Summary:    Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases.

Group:      Development/Libraries
License:    Apache-2.0
URL:        https://github.com/rebar/rebar
BuildRoot:  %{_tmppath}/%{name}-%{version}

Packager: Anthony Molinaro <anthonym@alumi.caltech.edu>

Provides: rebar = %{version}

%description
rebar is a self-contained Erlang script, so it's easy to distribute or even embed directly in a project. Where possible, rebar uses standard Erlang/OTP conventions for project structures, thus minimizing the amount of build configuration work. rebar also provides dependency management, enabling application writers to easily re-use common libraries from a variety of locations (git, hg, etc).

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
cp rebar $RPM_BUILD_ROOT/usr/bin/

%clean
rm -rf $RPM_BUILD_ROOT
rm -rf $RPM_BUILD_DIR/%{name}-%{version}

%files
%defattr(-,root,root,0755)
%{_bindir}/*

%changelog
* Mon Mar 12 2018 Anthony Molinaro <anthonym@alumni.caltech.edu>
- generalized to build from upstream source
