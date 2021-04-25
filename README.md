# ethannij-overlay
Ethannij's Gentoo Overlay

## OpenTabletDriver
OpenTabletDriver (source build) is currently broken due to some nuget certification issue that I can't figure out.

OpenTabletDriver-bin (the binary build) is basically the precompiled binary found at https://github.com/OpenTabletDriver/OpenTabletDriver/releases/tag/v0.5.2.3
The ebuild works as follows: call deps, grab tar, move files from tar into /usr/share/OpenTabletDriver, move otd and otd-gui scripts into /usr/bin/.

The bin ebuild also pulls the OpenTabletDriver-udev package which contains a 90-opentabletdriver.rules that I compiled and the Configurations folder which is moved into /usr/share/OpenTabletDriver.

So far, I have been unable to get portage to actually compile using dotnet so if you have any suggestions reach me at my discord (https://discord.gg/aq6KHNV).

All credit and files go to InfinityGhost (https://github.com/InfinityGhost) and the other developers of OpenTabletDriver (https://github.com/OpenTabletDriver) for creating the software.

The ebuilds themselves are mostly adapted from the aur PKGBUILD.

So far I am yet to include any init scripts or .desktop files.

## wine-osu
I found an interesting project here (https://blog.thepoon.fr/osuLinuxAudioLatency/#adjusting-latency) where ThePooN covers a version of wine they created to minimize audio latency in osu.
I created an ebuild for gentoo linux that replicates the same process used in the AUR package (https://aur.archlinux.org/packages/wine-osu/).

NOTE: For wine-osu to compile properly on GCC 10, you must add -fcommon to your package.env
