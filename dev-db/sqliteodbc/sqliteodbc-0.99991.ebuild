EAPI=8

inherit flag-o-matic multilib

DESCRIPTION="SQLite odbc interface driver"
HOMEPAGE="http://www.ch-werner.de/sqliteodbc/"
SRC_URI="http://www.ch-werner.de/sqliteodbc/sqliteodbc-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="winterface xml2"

RDEPEND="
	dev-db/sqlite
	dev-db/libiodbc
	xml2? ( app-text/xml2 )
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
		--prefix="${D}/usr"
		$(use_enable winterface winterface)
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
