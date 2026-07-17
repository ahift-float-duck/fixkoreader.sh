# fixkoreader.sh

A KUAL (SH_Integration) scriptlet for jailbroken Kindles that fixes a
KOReader install which ended up buried somewhere under
`/mnt/us/documents` instead of `/mnt/us/koreader`.

## How it lands on the device

1. Host `fixkoreader.sh` somewhere you can fetch raw text from (e.g. a
   GitHub gist - hit "Raw" and copy that URL).
2. On the Kindle: home -> menu (top right) -> Experimental Browser, and
   open the raw URL. If the browser downloads the file (rather than just
   displaying it as text), it lands in `/mnt/us/documents`.
3. Back at the home screen, a book named after the script should appear
   in the library. Tap it to run it - progress prints on screen.
4. Once it finishes, use KUAL to launch KOReader.

## What it does

- Searches `/mnt/us/documents` for a `koreader.sh` file (the marker for
  a real KOReader install) and moves that install's folder to
  `/mnt/us/koreader`.
- Does nothing if `/mnt/us/koreader` already exists - it won't overwrite
  or touch an existing install.
