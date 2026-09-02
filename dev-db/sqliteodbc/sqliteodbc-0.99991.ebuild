# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="SQLite odbc interface driver"
HOMEPAGE="http://www.ch-werner.de/sqliteodbc/"
SRC_URI="http://www.ch-werner.de/sqliteodbc/sqliteodbc-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-db/sqlite
	dev-db/libiodbc
"
DEPEND="
	${RDEPEND}
"

src_configure()
{
	append-cflags "-std=c17 -Wall -Wno-error=implicit-function-declaration"

	local myeconfargs=(
		--cache-file="${WORKDIR}"/config.cache
		--sysconfdir="${EPREFIX}"/etc/${PN}
		--enable-shared
	)

	econf "${myeconfargs[@]}"
}

src_install()
{
	# The installation script has a bug where it can't find libsqlite3odbc.lo.
	#emake drvinst

	dolib.so "${S}/.libs/libsqlite3odbc-${PV}.so"
	dosym "libsqlite3odbc-${PV}.so" "/usr/$(get_libdir)/libsqlite3odbc.so"
}
