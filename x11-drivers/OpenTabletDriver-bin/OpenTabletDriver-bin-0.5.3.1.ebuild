EAPI=7

inherit desktop

DESCRIPTION="A cross platform tablet driver (binary package)"
HOMEPAGE="https://github.com/OpenTabletDriver"

SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${PV}/OpenTabletDriver.linux-x64.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

SP="otd"

SLOT="0"
IUSE=""
DEPEND="
	x11-libs/libX11
	x11-libs/libXrandr
	dev-libs/libevdev
	x11-libs/gtk+:3
	|| ( dev-dotnet/dotnetcore-sdk-bin dev-dotnet/dotnetcore-sdk )
"
S=${WORKDIR}/OpenTabletDriver

src_install() {
	cd "${S}"

	# install -do root "${D}/usr/share/${PN}"

	exeinto "/usr/share/${PN}"
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

	insinto "/usr/share/${PN}"
	doins -r "Configurations"

	install -Dm 644 -o root "${FILESDIR}/90-${PN}.rules" -t "${D}/usr/lib/udev/rules.d"
	udevadm control --reload

	cd "${FILESDIR}"
	install -Dm 755 -o root "${SP}" -t "${D}/usr/bin"
	install -Dm 755 -o root "${SP}-gui" -t "${D}/usr/bin"

	doicon "opentabletdriver.png"
	make_desktop_entry /usr/bin/otd-gui OpenTabletDriver opentabletdriver Settings
}

pkg_postinst() {
	ewarn "If this is your first time installing,"
	ewarn "please replug your tablet."
}
