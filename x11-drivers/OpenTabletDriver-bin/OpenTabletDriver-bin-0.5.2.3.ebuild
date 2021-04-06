EAPI=7

DESCRIPTION="A cross platform tablet driver (binary package)"
HOMEPAGE="https://github.com/OpenTabletDriver"

SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${PV}/OpenTabletDriver.linux-x64.tar.gz -> ${NAME}.tar.gz"
KEYWORDS="~amd64"

NAME="OpenTabletDriver"
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
S=${WORKDIR}/${NAME}

src_prepare() {
    default
    ln -s ${WORKDIR}/${NAME} ${WORKDIR}/${NAME}-${PV}
}
   
src_install() {
    cd "${S}"

    install -do root "${D}/usr/share/${NAME}"

    for binary in *.dll *.json *.pdb; do
        install -Dm 755 -o root "$binary" -t "${D}/usr/share/${NAME}"
    done

    #install -Dm 644 -o root "${S}/${NAME}-udev/90-${LP}.rules" -t "${D}/usr/lib/udev/rules.d"
    cp -r "${S}/Configurations" "${D}/usr/share/${NAME}/"

    install -Dm 755 -o root "${NAME}.Daemon" -t "${D}/usr/bin/${NAME}-daemon"
    install -Dm 755 -o root "${NAME}.UX.Gtk" -t "${D}/usr/bin/${NAME}-gui"
    install -Dm 755 -o root "${NAME}.Console" -t "${D}/usr/bin/${NAME}"
}