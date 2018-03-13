%define tag OTP-%{ver}
%define upstream %{repo}

Name:           erlang
Version:        %{ver}
Release:        %{rel}
Summary:        General-purpose programming language and runtime environment

Group:          Development/Languages
License:        Apache Version 2.0
URL:            https://github.com/erlang/otp
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Packager: Anthony Molinaro <anthonym@alumi.caltech.edu>

BuildRequires: ncurses-devel
BuildRequires: openssl-devel
BuildRequires: unixODBC-devel
BuildRequires: gd-devel
BuildRequires: jdk
BuildRequires: flex
BuildRequires: m4

%description
Erlang is a general-purpose programming language and runtime
environment. Erlang has built-in support for concurrency, distribution
and fault tolerance. Erlang is used in several large telecommunication
systems from Ericsson.

%debug_package
%prep
if [ ! -d erlang-otp ] ; then
  git clone %{upstream}
fi
cd erlang-otp
git checkout master
git pull
git checkout %{tag}
./otp_build autoconf

%build
cd erlang-otp
CFLAGS="$RPM_OPT_FLAGS -fno-strict-aliasing" ./configure --enable-dynamic-ssl-lib --enable-hipe --prefix=%{_prefix} --libdir=%{_prefix}/lib64
chmod -R u+w .
make
make docs

%install
rm -rf $RPM_BUILD_ROOT
cd erlang-otp
make DESTDIR=$RPM_BUILD_ROOT install
make DESTDIR=$RPM_BUILD_ROOT install-docs

# clean up a few permissions
find $RPM_BUILD_ROOT%{_libdir}/erlang -perm 0775 | xargs chmod 755
find $RPM_BUILD_ROOT%{_libdir}/erlang -name Makefile | xargs chmod 644
find $RPM_BUILD_ROOT%{_libdir}/erlang -name \*.o | xargs chmod 644

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%{_bindir}/*
%{_libdir}/erlang

%changelog
* Mon Mar 12 2018 Anthony Molinaro <anthonym@alumni.caltech.edu>
- generalized to build from upstream source and take version as environment variables.
