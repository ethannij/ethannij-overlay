EAPI=7

DESCRIPTION="A compatibility layer for running Windows programs - Staging branch, optimized for audio low latency on osu! (by ThePooN)"
HOMEPAGE="https://blog.thepoon.fr/osuLinuxAudioLatency/"

SRC_URI=("https://github.com/wine-staging/wine-staging/archive/v${PV}.tar.gz https://dl.winehq.org/wine/source/3.x/wine-${PV}.tar.xz")
SLOT="0"

KEYWORDS="~amd64"


PATCHES=(
    "${FILESDIR}/harmony-fix.diff"
    "${FILESDIR}/winealsa_latency.patch"
    "${FILESDIR}/winepulse_latency.patch"
)

pkgname=wine-osu
pkgver=3.12
pkgrel=2
_pkgbasever=${pkgver/rc/-rc}

S=${WORKDIR}/wine-${PV}

src_prepare() {
    # Allow ccache to work
    #mv ${WORKDIR}/wine-${PV} ${S}

    # apply wine-staging patchset
    ${WORKDIR}/wine-staging-$_pkgbasever/patches/patchinstall.sh DESTDIR="${WORKDIR}/wine-${PV}" --all

    export CFLAGS="${CFLAGS/-fno-plt/}"
    export LDFLAGS="${LDFLAGS/,-z,now/}"

    #patch -d ${WORKDIR}/wine-${PV} -Np1 < ${FILESDIR}/harmony-fix.diff

    #patch -d ${WORKDIR}/wine-${PV} -Np1 < ${FILESDIR}/winealsa_latency.patch
    #patch -d ${WORKDIR}/wine-${PV} -Np1 < ${FILESDIR}/winepulse_latency.patch

    sed 's|OpenCL/opencl.h|CL/opencl.h|g' -i ${WORKDIR}/wine-${PV}/configure*

    rm -rf ${WORKDIR}/$pkgname-{32,64}-build
    mkdir ${WORKDIR}/$pkgname-{32,64}-build

    default
}

src_compile() {
    cd ${WORKDIR}/wine-${PV}
    emake distclean
    echo "Building Wine-64..."

    cd "${WORKDIR}/$pkgname-64-build"
    ../wine-${PV}/configure \
        --prefix=${D}/opt/wine-osu \
        --libdir=${D}/opt/wine-osu/lib \
        --with-x \
        --with-gstreamer \
        --without-pcap \
        --enable-win64 \
        --with-xattr


    emake

    echo "Building Wine-32..."

    export PKG_CONFIG_PATH="/usr/lib/pkgconfig"
    cd "${WORKDIR}/$pkgname-32-build"
    ../wine-${PV}/configure \
        --prefix=${D}/opt/wine-osu \
        --with-x \
        --with-xattr \
        --without-pcap \
        --libdir=/opt/wine-osu/lib32 \
        --with-wine64="${WORKDIR}/$pkgname-64-build"

    emake
}

src_install() {
    echo "Packaging Wine-32..."
    cd "${WORKDIR}/$pkgname-32-build"

    emake prefix="${D}/opt/wine-osu" \
        libdir="${D}/opt/wine-osu/lib32" \
        dlldir="${D}/opt/wine-osu/lib32/wine" install

    echo "Packaging Wine-64..."
    cd "${WORKDIR}/$pkgname-64-build"
    emake prefix="${D}/opt/wine-osu" \
        libdir="${D}/opt/wine-osu/lib" \
        dlldir="${D}/opt/wine-osu/lib/wine" install
}
