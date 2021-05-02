EAPI=7

inherit desktop

DESCRIPTION="Cross platform tablet driver (binary package)"
HOMEPAGE="https://github.com/OpenTabletDriver"
SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/archive/refs/tags/v${PV}.tar.gz https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${PV}/OpenTabletDriver.linux-x64.tar.gz -> OpenTabletDriver-${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	x11-libs/libX11
	x11-libs/libXrandr
	dev-libs/libevdev
	x11-libs/gtk+:3
	|| ( dev-dotnet/dotnet-sdk-bin dev-dotnet/dotnet-runtime-bin )
"


S="${WORKDIR}/${pkgname}"
src_install() {
	local pkgname=OpenTabletDriver
	local LP=opentabletdriver
	local SP="otd"

	cd "${S}" || die

	# install -do root "${D}/usr/share/${PN}"

	exeinto "/usr/share/${pkgname}"
	exeopts -o root -Dm755

	for binary in *.dll *.json; do
		# install -Dm 755 -o root "$binary" -t "${D}/usr/share/${PN}"
		doexe "$binary"
		#fowners root "$binary"
	done

	for bin in *.Daemon *.UX.Gtk *.Console; do
		# install -Dm 755 -o root "$bin" -t "${D}/usr/share/${PN}"
		doexe "$bin"
	done

	insinto "/usr/share/${pkgname}"
	doins -r "Configurations"

	doins "${S}/99-${LP}.rules" "${D}/usr/lib/udev/rules.d"
	#install -Dm 644 -o root "${S}/99-${LP}.rules" -t "${D}/usr/lib/udev/rules.d"
	udevadm control --reload || die

	cd "${FILESDIR}" || die
	#install -Dm 755 -o root "${SP}" -t "${D}/usr/bin"
	dobin "${SP}"
	#install -Dm 755 -o root "${SP}-gui" -t "${D}/usr/bin"
	dobin "${SP}-gui"

	cd ${WORKDIR}/OpenTabletDriver-${PV}/OpenTabletDriver.UX/Assets || die
	doicon "otd.png" 
	make_desktop_entry /usr/bin/otd-gui OpenTabletDriver otd Settings
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
    elog "Please replug your tablet before attempting to use the driver"
	fi
	
	#ewarn "If this is your first time installing,"
	#ewarn "please replug your tablet."
}
