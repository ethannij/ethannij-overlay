EAPI=7

DESCRIPTION="A cross platform tablet driver"
HOMEPAGE="https://github.com/OpenTabletDriver"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/OpenTabletDriver/OpenTabletDriver.git"
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
    cd "${S}"
    git clone "https://github.com/OpenTabletDriver/OpenTabletDriver-udev"
    cd "${S}/${PN}-udev/.modules"
    rmdir "${PN}"
    ln -s "${S}/${PN}" "${PN}"
    default
}

src_compile() {
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

    cd "${S}/${PN}"
    PREFIX=$(git describe --long --tags | sed 's/-.*//;s/v//')
    SUFFIX=$(git describe --long --tags | sed 's/^[^-]*-//;s/\([^-]*-g\)/r\1/;s/-/./g')

    dotnet publish        OpenTabletDriver.Daemon   \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --self-contained  false                     \
        --output          "./${PN}/out"         \
        /p:VersionPrefix="$PREFIX"                  \
        /p:SuppressNETCoreSdkPreviewMessage=true    \
        /p:PublishTrimmed=false

        dotnet publish        OpenTabletDriver.Console  \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --self-contained  false                     \
        --output          "./${PN}/out"         \
        --version-suffix  "$SUFFIX"                 \
        /p:VersionPrefix="$PREFIX"                  \
        /p:SuppressNETCoreSdkPreviewMessage=true    \
        /p:PublishTrimmed=false

    dotnet publish        OpenTabletDriver.UX.Gtk   \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --self-contained  false                     \
        --output          "./${PN}/out"         \
        --version-suffix  "$SUFFIX"                 \
        /p:VersionPrefix="$PREFIX"                  \
        /p:SuppressNETCoreSdkPreviewMessage=true    \
        /p:PublishTrimmed=false

    cd "${S}/${PN}-udev"
    dotnet build          OpenTabletDriver.udev     \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --output          "./${PN}.udev/out"    \
        /p:SuppressNETCoreSdkPreviewMessage=true

    dotnet "./${PN}.udev/out/${PN}.udev.dll" \
        "${S}/${PN}/${PN}/Configurations" \
        "90-${LP}.rules" > /dev/null
}

src_install() {
    cd "${S}"

    install -do root "${D}/usr/share/${PN}"

    cd "${S}/${PN}/${PN}/out"
    for binary in *.dll *.json *.pdb; do
        install -Dm 755 -o root "$binary" -t "${D}/usr/share/${PN}"
    done
    cd "${S}"

    sed -i "s/OTD_VERSION/${PV}/" "${PN}.desktop"

    install -Dm 644 -o root "${S}/${PN}-udev/90-${LP}.rules" -t "${D}/usr/lib/udev/rules.d"
    install -Dm 644 -o root "${S}/${PN}/${PN}.UX/Assets/${SP}.png" -t "${D}/usr/share/pixmaps"
    cp -r "${S}/${PN}/${PN}/Configurations" "${D}/usr/share/${PN}/"

    install -Dm 755 -o root "$_spkgname" -t "${D}/usr/bin"
    install -Dm 755 -o root "$_spkgname-gui" -t "${D}/usr/bin"
    #install -Dm 644 -o root "${LP}.service" -t "${D}/usr/lib/systemd/user"
    install -Dm 644 -o root "${PN}.desktop" -t "${D}/usr/share/applications"
}