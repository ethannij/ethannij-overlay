EAPI=7

DESCRIPTION="Necessary udev files for Open Tablet Driver"
HOMEPAGE="https://github.com/OpenTabletDriver"

_pkgname="OpenTabletDriver"
_lpkgname="opentabletdriver"

inherit git-r3
EGIT_REPO_URI="https://github.com/OpenTabletDriver/OpenTabletDriver-udev"

KEYWORDS="~amd64"

SLOT="0"
IUSE=""

DEPEND="|| ( dev-dotnet/dotnetcore-sdk-bin dev-dotnet/dotnetcore-sdk )"

src_compile() {
    cd "${S}"

    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

    PREFIX=$(git describe --long --tags | sed 's/-.*//;s/v//')
    SUFFIX=$(git describe --long --tags | sed 's/^[^-]*-//;s/\([^-]*-g\)/r\1/;s/-/./g')

    dotnet build          OpenTabletDriver.udev     \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --output          "./out"    \
        /p:SuppressNETCoreSdkPreviewMessage=true

    dotnet "./$_pkgname.udev/out/$_pkgname.udev.dll" \
        "${S}/$_pkgname/Configurations" \
        "90-$_lpkgname.rules" > /dev/null
}

src_install() {
    install -Dm 644 -o root "${S}/90-$_lpkgname.rules" -t "${D}/usr/lib/udev/rules.d"
    cp -r "${S}/$_pkgname/Configurations" "${D}/usr/share/$_pkgname/"
}