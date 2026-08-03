# fixkoreader.sh

A KUAL (SH_Integration) scriptlet for jailbroken Kindles that fixes a
KOReader install which ended up buried somewhere under
`/mnt/us/documents` instead of `/mnt/us/koreader`.

## Requirements

- **A jailbroken Kindle.** This only works on devices that already have
  the jailbreak applied (unlocked root filesystem). Stock, un-jailbroken
  Kindles can't run arbitrary shell scripts at all.
- **KUAL installed**, with the **SH_Integration** extension present. You
  can confirm this without opening KUAL at all: if a "Run Hotfix" (or
  similarly named) book already shows up in your library, SH_Integration
  is active and tap-to-run `.sh` scriptlets already work on this device.
- **A way to get the file into `/mnt/us/documents`.** Two routes, in
  order of reliability:
  - **USB** (recommended, always works): plug the Kindle into a
    computer, it mounts as a USB drive, copy `fixkoreader.sh` straight
    into the `documents` folder, eject.
  - **Wifi + Experimental Browser** (works sometimes): fetch a raw-text
    URL of the script from the device's browser. Whether this actually
    works depends on the browser's filetype handling — see
    Troubleshooting below.
- **Wifi, if using the browser route.** Safe to enable on a device
  where the Amazon update binaries have already been disabled/renamed —
  otherwise an unpatched device that phones home can pull down an OTA
  update that re-locks the jailbreak.

## How it lands on the device

### Route A: USB (reliable)

1. Plug the Kindle into a computer via USB. It mounts as a normal mass
   storage drive.
2. Copy `fixkoreader.sh` into the `documents` folder on that drive.
3. Eject/unmount safely, then unplug.
4. Back at the Kindle home screen, a book named after the script
   ("Fix KOReader") should appear. Tap it — progress prints on screen.
5. Once it finishes, use KUAL to launch KOReader.

### Route B: Wifi + Experimental Browser (not guaranteed)

1. Host `fixkoreader.sh` somewhere you can fetch raw text from — a
   GitHub repo's raw URL (`raw.githubusercontent.com/...`) or a gist's
   "Raw" link both work.
2. On the Kindle: home -> menu (top right) -> Experimental Browser, and
   open the raw URL.
3. Watch what happens:
   - **It downloads** -> the file lands in `/mnt/us/documents` and you
     continue from step 4 of Route A.
   - **It renders as plain text on screen instead** -> this is the
     stock browser's filetype filter refusing to save it. There is no
     known workaround for this short of USB (Route A). Don't keep
     retrying different URLs expecting a different result — it's a
     browser-side block, not a hosting problem.

## Troubleshooting

- **Captive portals (e.g. in-flight wifi):** many public/paid wifi
  networks require accepting a terms/payment page before granting real
  internet access. The Experimental Browser is old and may fail to
  render or submit that page, leaving you connected to the network with
  no actual route out. If wifi seems "on" but nothing loads, this is
  the likely cause.
- **TLS/HTTPS failures:** the Experimental Browser's TLS stack is old.
  Fetching an HTTPS raw URL (e.g. `raw.githubusercontent.com`) can fail
  outright on some firmware versions rather than falling back to
  showing text. If the page won't load at all (not even as text),
  that's a TLS incompatibility, not the filetype-filter issue above.
- **Multiple `koreader.sh` matches:** if KOReader got extracted more
  than once under `documents`, the script picks the first match it
  finds and lists the others so you can clean up manually afterward.

## What it does

- Searches `/mnt/us/documents` for a `koreader.sh` file (the marker for
  a real KOReader install) and moves that install's folder to
  `/mnt/us/koreader`.
- Does nothing if `/mnt/us/koreader` already exists - it won't overwrite
  or touch an existing install.

## Scriptlet metadata (why the header comments matter)

SH_Integration reads a small set of `#`-prefixed header lines at the top
of the script to control how it shows up in the library and runs:

- `# Name: <title>` - the book title shown in the library. Without this
  the book would just be titled after the raw filename.
- `# Author: <name>` - the author metadata shown alongside it.
- `# Icon: <path>` - optional custom cover icon (not used here).
- `# UseHooks` - opts into lifecycle hook functions instead of running
  top-to-bottom (not used here - this script is a simple linear run).
- `# DontUseFBInk` - opts out of the default behavior, which is to pipe
  the script's stdout to the e-ink screen live via FBInk. This script
  relies on the default (FBInk on) for its on-screen progress output.

If you're adapting this script or writing your own scriptlet, keep the
`# Name:`/`# Author:` lines as the first two comment lines after the
shebang - that's the convention SH_Integration expects.

## Contributing

Issues and PRs welcome. Keep changes POSIX `sh` (no bashisms - the
on-device shell is busybox ash) and run `shellcheck -s sh fixkoreader.sh`
before submitting; CI runs the same check on every push and PR.

## Getting a terminal without KOReader

KOReader's own Terminal plugin is the usual way people get an
interactive shell on a jailbroken Kindle — but that's not available
here, since KOReader isn't working yet (that's the whole problem this
script solves). A few ways to get shell access that don't depend on
KOReader:

- **SH_Integration scriptlets (what this script uses).** Not an
  interactive shell — each tap runs one script start-to-finish and
  prints its output. Fine for canned one-shot fixes like this one, not
  for poking around interactively.
- **USBNetwork (KUAL extension).** If installed, it brings up a USB
  network interface when you plug into a computer, and you telnet or
  ssh in from the computer over that link. This is the standard way to
  get a real interactive prompt on these jailbreaks. Requires the USB
  cable — same constraint as Route A above.
- **A terminal emulator KUAL extension (e.g. "kterm").** Some jailbreak
  extension packs include an on-device terminal emulator that draws a
  shell prompt directly on the e-ink screen, no cable or KOReader
  needed. Whether you have this depends on which extensions got
  installed during the jailbreak — check the KUAL menu for anything
  called "Terminal."
- **Wifi telnet/ssh daemon.** A few jailbreak recipes optionally enable
  telnet or dropbear ssh listening on the wifi interface instead of (or
  in addition to) USBNetwork. If that was set up, you can connect from
  the same wifi network without a cable. Not present unless it was
  explicitly configured during setup.

If none of those are available, USBNetwork is the fallback everyone
ends up using — it's why jailbreak guides treat the USB cable as
mandatory hardware rather than optional.
