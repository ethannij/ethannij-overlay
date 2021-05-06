# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRITPION="An all-in-one tool for extracting/creating 3ds roms"
HOMEPAGE="https://github.com/dnasdw/3dstool"
EGIT_REPO_URI="https://github.com/dnasdw/3dstool.git"

LICENSE="MIT"
SLOT=0
IUSE=""

DEPEND="
    dev-util/cmake
    dev-libs/libiconv
"

src_configure() {
    mkdir "${S}/build"
    cd "${S}/build"
}

src_compile() {
	cd "${S}/build"
	cmake -DUSE_DEP=OFF .. || die
    emake
}

src_install() {
	cd "${S}/build"
    emake "install"
	dobin "${S}/bin/3dstool"
}
