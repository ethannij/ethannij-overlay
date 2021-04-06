EAPI=7

DESCRIPTION="A cross platform tablet driver (binary package)"
HOMEPAGE="https://github.com/OpenTabletDriver"

SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${PV}/OpenTabletDriver.linux-x64.tar.gz -> ${PN}.tar.gz"
KEYWORDS="~amd64"

LP="opentabletdriver"
SP="otd"

SLOT="0"
IUSE=""
DEPEND="
    x11-libs/libX11
    x11-libs/libXrandr
    dev-libs/libevdev
    x11-libs/gtk+
    || ( dev-dotnet/dotnetcore-sdk-bin dev-dotnet/dotnetcore-sdk )
"
src_prepare() {
    default
}
   
src_install() {
    cd "${S}"

    install -do root "${D}/usr/share/${PN}"

    for binary in *.dll *.json *.pdb; do
        install -Dm 755 -o root "$binary" -t "${D}/usr/share/${PN}"
    done

    #install -Dm 644 -o root "${S}/${PN}-udev/90-${LP}.rules" -t "${D}/usr/lib/udev/rules.d"
    cp -r "${S}/Configurations" "${D}/usr/share/${PN}/"

    install -Dm 755 -o root "${PN}.Daemon" -t "${D}/usr/bin/${PN}-daemon"
    install -Dm 755 -o root "${PN}.UX.Gtk" -t "${D}/usr/bin/${PN}-gui"
    install -Dm 755 -o root "${PN}.Console" -t "${D}/usr/bin/${PN}"
}