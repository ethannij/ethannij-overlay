# ethannij-overlay
Ethannij's Gentoo Overlay

To use my overlay `# emerge eselect-repository`
`# eselect repository add ethannij-overlay git https://github.com/ethannij/ethannij-overlay`
`# emerge --sync ethannij-overlay`

## OpenTabletDriver

Moved to guru overlay.
https://github.com/gentoo/guru

## wine-osu
I found an interesting project here (https://blog.thepoon.fr/osuLinuxAudioLatency/#adjusting-latency) where ThePooN covers a version of wine they created to minimize audio latency in osu.
I created an ebuild for gentoo linux that replicates the same process used in the AUR package (https://aur.archlinux.org/packages/wine-osu/).

NOTE: For wine-osu to compile properly on GCC 10, you must add -fcommon to your package.env
