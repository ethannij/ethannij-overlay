EAPI=7

DESCRIPTION="A cross platform tablet driver"
HOMEPAGE="https://github.com/OpenTabletDriver"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI=("https://github.com/OpenTabletDriver/OpenTabletDriver.git" "git+https://github.com/OpenTabletDriver/OpenTabletDriver-udev")
else
    #non 9999 WIP
    SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${PV}/OpenTabletDriver.linux-x64.tar.gz -> ${PN}.tar.gz"
    KEYWORDS="~amd64"
fi

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

}

src_compile() {
     
}