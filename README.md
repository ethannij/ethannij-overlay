# ethannij-overlay
Ethannij's Gentoo Overlay

To use my overlay `# emerge eselect-repository`
`# eselect repository add ethannij-overlay git https://github.com/ethannij/ethannij-overlay`
`# emerge --sync ethannij-overlay`

## OpenTabletDriver

OpenTabletDriver-bin (the binary build) is basically the precompiled binary found at https://github.com/OpenTabletDriver/OpenTabletDriver/releases/tag/v{package_version}
The ebuild works as follows: call deps, grab tar, move files from tar into /usr/share/OpenTabletDriver, move otd and otd-gui scripts into /usr/bin/.

The OpenTabletDriver (source) package has been fixed.
You must emerge it with `FEATURES=-network-sandbox`
To do so, create a file /etc/portage/env/nonetworksandbox.conf and add `FEATURES="-network-sandbox"`

Now edit the file /etc/portage/package.env and add `x11-drivers/OpenTabletDriver nonetworksandbox.conf` inside.

All credit and files go to InfinityGhost (https://github.com/InfinityGhost) and the other developers of OpenTabletDriver (https://github.com/OpenTabletDriver) for creating the software.

The source ebuild is based on the aur PKGBUILD.

So far I am yet to include any init scripts.

Thanks to https://github.com/nerd for helping me clean the existing OTD-bin ebuild as well as suggesting solutions for the source builds

## wine-osu
I found an interesting project here (https://blog.thepoon.fr/osuLinuxAudioLatency/#adjusting-latency) where ThePooN covers a version of wine they created to minimize audio latency in osu.
I created an ebuild for gentoo linux that replicates the same process used in the AUR package (https://aur.archlinux.org/packages/wine-osu/).

NOTE: For wine-osu to compile properly on GCC 10, you must add -fcommon to your package.env
