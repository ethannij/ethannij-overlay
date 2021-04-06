EAPI=7

DESCRIPTION="Necessary udev files for Open Tablet Driver"
HOMEPAGE="https://github.com/OpenTabletDriver"

_pkgname="OpenTabletDriver"
_lpkgname="opentabletdriver"

inherit git-r3
EGIT_REPO_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/tree/master/OpenTabletDriver/Configurations"

KEYWORDS="~amd64"

SLOT="0"
IUSE=""

src_install() {
    install -Dm 644 -o root "${FILESDIR}/90-$_lpkgname.rules" -t "${D}/usr/lib/udev/rules.d"
    cp -r "${S}/Configurations" "${D}/usr/share/$_pkgname/"
}