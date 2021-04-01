EAPI=7

DESCRIPTION="A cross platform tablet driver"
HOMEPAGE="https://github.com/OpenTabletDriver"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EFIT_REPO_URI="https://github.com/OpenTabletDriver/OpenTabletDriver.git"
else
    SRC_URI="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${PV}/OpenTabletDriver.linux-x64.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64"
fi

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
    cd "${S}/${P}-udev/.modules"
    rmdir "${P}"
    ln -s "${S}/${P}" "${P}"
}

src_compile() {
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

    cd "${S}/${P}"
    PREFIX=$(git describe --long --tags | sed 's/-.*//;s/v//')
    SUFFIX=$(git describe --long --tags | sed 's/^[^-]*-//;s/\([^-]*-g\)/r\1/;s/-/./g')

    dotnet publish        OpenTabletDriver.Daemon   \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --self-contained  false                     \
        --output          "./${P}/out"              \
        /p:VersionPrefix="$PREFIX"                  \
        /p:SuppressNETCoreSdkPreviewMessage=true    \
        /p:PublishTrimmed=false

    dotnet publish        OpenTabletDriver.Console  \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --self-contained  false                     \
        --output          "./${P}/out"              \
        --version-suffix  "$SUFFIX"                 \
        /p:VersionPrefix="$PREFIX"                  \
        /p:SuppressNETCoreSdkPreviewMessage=true    \
        /p:PublishTrimmed=false

    dotnet publish        OpenTabletDriver.UX.Gtk   \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --self-contained  false                     \
        --output          "./${P}/out"              \
        --version-suffix  "$SUFFIX"                 \
        /p:VersionPrefix="$PREFIX"                  \
        /p:SuppressNETCoreSdkPreviewMessage=true    \
        /p:PublishTrimmed=false

    cd "${S}/${P}-udev"
    dotnet build          OpenTabletDriver.udev     \
        --configuration   Release                   \
        --framework       net5                      \
        --runtime         linux-x64                 \
        --output          "./${P}.udev/out"         \
        /p:SuppressNETCoreSdkPreviewMessage=true

    dotnet "./${P}.udev/out/${P}.udev.dll" \
        "${S}/${P}/${P}/Configurations" \
        "90-${LP}.rules" > /dev/null
}

src_install() {
    LP=sed -e 's/\(.*\)/\L\1/' <<< "${P}"
    SP=otd
    cd "${S}"

    install -do root "${D}/usr/share/${P}"

    cd "${S}/${P}/${P}/out"
    for binary in *.dll *.json *.pdb; do
        install -Dm 755 -o root "$binary" -t "${D}/usr/share/${P}"
    done
    cd "${S}"

    sed -i "s/OTD_VERSION/${PV}/" "${P}.desktop"

    install -Dm 644 -o root "${S}/${P}-udev/90-${LP}.rules" -t "${D}/usr/lib/udev/rules.d"
    install -Dm 644 -o root "${S}/${P}/${P}.UX/Assets/${SP}.png" -t "${D}/usr/share/pixmaps"
    cp -r "${S}/${P}/${P}/Configurations" "${D}/usr/share/${P}/"

    install -Dm 755 -o root "${SP}" -t "${D}/usr/bin"
    install -Dm 755 -o root "${SP}-gui" -t "${D}/usr/bin"
    #install -Dm 644 -o root "${LP}.service" -t "${D}/usr/lib/systemd/user"
    install -Dm 644 -o root "${P}.desktop" -t "${D}/usr/share/applications"
}