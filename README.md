# ethannij-overlay
Ethannij's Gentoo Overlay

To use my overlay `# emerge eselect-repository`
`# eselect repository add ethannij-overlay git https://github.com/ethannij/ethannij-overlay`
`# emerge --sync ethannij-overlay`

## OpenTabletDriver

OpenTabletDriver-bin (the binary build) is basically the precompiled binary found at https://github.com/OpenTabletDriver/OpenTabletDriver/releases/tag/v{package_version}
The ebuild works as follows: call deps, grab tar, move files from tar into /usr/share/OpenTabletDriver, move otd and otd-gui scripts into /usr/bin/.

### What happened to OpenTabletDriver source build?
When a software is compiled using C for example, there are compile flags put in your make.conf that make your binary unique. Dotnet lacks that functionality, or at least it is not used common enough for flags to be in your make.conf. The source build also requires that you disable network sandboxing, which is poor practice, becuase nuget (dotnet package manager IG) tries to pull dependencies from the internet and fails to compile otherwise. All together, compiling OTD from source has no benefits but quite a bit of flaws so I decided to remove it.

All credit and files go to InfinityGhost (https://github.com/InfinityGhost) and the other developers of OpenTabletDriver (https://github.com/OpenTabletDriver) for creating the software.

So far I am yet to include any init scripts.

Thanks to https://github.com/nerd for helping me clean the existing OTD-bin ebuild as well as suggesting solutions for the source builds

## wine-osu
I found an interesting project here (https://blog.thepoon.fr/osuLinuxAudioLatency/#adjusting-latency) where ThePooN covers a version of wine they created to minimize audio latency in osu.
I created an ebuild for gentoo linux that replicates the same process used in the AUR package (https://aur.archlinux.org/packages/wine-osu/).

NOTE: For wine-osu to compile properly on GCC 10, you must add -fcommon to your package.env
