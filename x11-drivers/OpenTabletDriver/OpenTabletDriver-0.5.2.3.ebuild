EAPI=7

DESCRIPTION="A cross platform tablet driver"
HOMEPAGE="https://github.com/OpenTabletDriver"
#SRC_URI="https://github.com/OpenTabletDriver.git"
SRC_URI="https://github.com/OpenTabletDriver/archive/refs/tags/v0.5.2.3.tar.gz"

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

src_prepare() {
    default
}

src_compile() {
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

    dotnet publish        OpenTabletDriver.Daemon   \
         --configuration   Release                   \
         --framework       net5                      \
         --runtime         linux-x64                 \
         --self-contained  false                     \
         --output          "./OpenTabletDriver/out"         \
         /p:SuppressNETCoreSdkPreviewMessage=true    \
         /p:PublishTrimmed=false

    dotnet publish        OpenTabletDriver.Console  \
         --configuration   Release                   \
         --framework       net5                      \
         --runtime         linux-x64                 \
         --self-contained  false                     \
         --output          "./OpenTabletDriver/out"         \
         /p:SuppressNETCoreSdkPreviewMessage=true    \
         /p:PublishTrimmed=false

    dotnet publish        OpenTabletDriver.UX.Gtk   \
         --configuration   Release                   \
         --framework       net5                      \
         --runtime         linux-x64                 \
         --self-contained  false                     \
         --output          "./OpenTabletDriver/out"         \
         /p:SuppressNETCoreSdkPreviewMessage=true    \
         /p:PublishTrimmed=false

    cd "${S}/OpenTabletDriver-udev"
    dotnet build          OpenTabletDriver.udev     \
         --configuration   Release                   \
         --framework       net5                      \
         --runtime         linux-x64                 \
         --output          "./OpenTabletDriver.udev/out"    \
         /p:SuppressNETCoreSdkPreviewMessage=true

    dotnet "./OpenTabletDriver.udev/out/OpenTabletDriver.udev.dll" \
         "${S}/OpenTabletDriver/Configurations" \
         "90-opentabletdriver.rules" > /dev/null
}

src_install() {
    cd ${S}

    install -do root "${D}/usr/share/OpenTabletDriver"

    cd "${S}/OpenTabletDriver/out"
    for binary in *.dll *.json *.pdb; do
         install -Dm 755 -o root "$binary" -t "${D}/usr/share/OpenTabletDriver"
    done
    cd "${S}"

    sed -i "s/OTD_VERSION/0.5.2.3/" "OpenTabletDriver.desktop"

    install -Dm 644 -o root "${S}/OpenTabletDriver-udev/90-opentabletdriver.rules" -t "${D}/usr/lib/udev/rules.d"
    install -Dm 644 -o root "${S}/OpenTabletDriver.UX/Assets/otd.png" -t "${D}/usr/share/pixmaps"
    cp -r "${S}/OpenTabletDriver/Configurations" "${D}/usr/share/OpenTabletDriver/"

    install -Dm 755 -o root "otd" -t "${D}/usr/bin"
    install -Dm 755 -o root "otd-gui" -t "${D}/usr/bin"
    #install -Dm 644 -o root "opentabletdriver.service" -t "${S}/usr/lib/systemd/user"
    #install -Dm 644 -o root "OpenTabletDriver.desktop" -t "/usr/share/applications"
}