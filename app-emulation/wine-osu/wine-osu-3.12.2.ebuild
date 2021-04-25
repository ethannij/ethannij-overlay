EAPI=7

DESCRIPTION="A compatibility layer for running Windows programs - Staging branch, optimized for audio low latency on osu! (by ThePooN)"
HOMEPAGE="https://blog.thepoon.fr/osuLinuxAudioLatency/"

SRC_URI="https://github.com/wine-staging/wine-staging/archive/v3.12.tar.gz"

pkgname=wine-osu
pkgver=3.12
pkgrel=2
_pkgbasever=${pkgver/rc/-rc}

src_prepare() {
    # Allow ccache to work
    mv wine-$_pkgbasever $pkgname

    # apply wine-staging patchset
    pushd wine-staging-$_pkgbasever/patches
    ./patchinstall.share DESTDIR="${S}" --all
    popd

}

src_compile() {

}