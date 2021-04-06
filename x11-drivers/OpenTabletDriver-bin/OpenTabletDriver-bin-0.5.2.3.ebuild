EAPI=7

DESCRIPTION="A cross platform tablet driver (binary package)"
HOMEPAGE="https://github.com/OpenTabletDriver"

SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${PV}/OpenTabletDriver.linux-x64.tar.gz -> ${NAME}-${PV}.tar.gz"

KEYWORDS="~amd64"

NAME="OpenTabletDriver"
LP="opentabletdriver"
SP="otd"

SLOT="0"
IUSE=""
DEPEND="
    x11-drivers/OpenTabletDriver-udev::ethannij-overlay
    x11-libs/libX11
    x11-libs/libXrandr
    dev-libs/libevdev
    x11-libs/gtk+
    || ( dev-dotnet/dotnetcore-sdk-bin dev-dotnet/dotnetcore-sdk )
"
S=${WORKDIR}/${NAME}

src_prepare() {
    default
    ln -s ${WORKDIR}/${NAME} ${WORKDIR}/${NAME}-${PV} 
}
   
src_install() {
    cd "${S}"

    install -do root "${D}/usr/share/${NAME}"

    for binary in *.dll *.json; do
        install -Dm 755 -o root "$binary" -t "${D}/usr/share/${NAME}"
    done

    for bin in *.Daemon *.UX.Gtk *.Console; do
        install -Dm 755 -o root "$bin" -t "${D}/usr/share/${NAME}"
    done

    cd "${FILESDIR}"
    install -Dm 755 -o root "${SP}" -t "${D}/usr/bin"
    install -Dm 755 -o root "${SP}-gui" -t "${D}/usr/bin"
}