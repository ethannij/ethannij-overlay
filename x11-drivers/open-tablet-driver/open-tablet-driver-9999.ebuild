EAPI=7

DESCRIPTION="A cross platform tablet driver"
HOMEPAGE="https://github.com/OpenTabletDriver/OpenTabletDriver"
SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/archive/refs/tags/v0.5.2.3.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
    x11-libs/libX11
    x11-libs/libXrandr
    dev-libs/libevdev
    x11-libs/gtk+
"
RDEPEND="${DEPEND}"
BDEPEND=""
