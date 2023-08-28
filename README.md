# tdbin.hexpat
Parses the proprietary TDBIN format used in [Teardown](https://store.steampowered.com/app/1167630/Teardown/).

Written in [the Pattern Language](https://docs.werwolv.net/pattern-language/).

Intended for use in [ImHex](https://imhex.werwolv.net/).

## Usage
1. Install [ImHex](https://imhex.werwolv.net/).
2. If your file is a base game level in `data/bin/` (skip this step if it's `quicksave.bin`), decompress your TDBIN file with `zlib-flate -uncompress < foo.bin > bar.bin`.
3. Open your TDBIN file in ImHex.
4. Go to "File", "Load pattern...", "Browse...", and load [`tdbin.hexpat`](tdbin.hexpat) (or open it in a text editor and copy and paste it into the "Pattern editor").
5. Click the play button under "Console" under "Pattern editor".
6. Look through the parsed data under the "Pattern Data" or "Hex editor" tabs.

## Compatibility
This should support every version from 0.4.5 to 1.4.0, and the performance test (0.3.0). I haven't added support for every entity type yet, and I can't load any of the larger levels because I run out of RAM. Patches don't make any changes to the binary level format (that I know of), so they don't affect compatibility.

## License
Copyright (c) 2022 x4fx77x4f

This software is released under the GNU General Public License version 3. The license terms can be found in [the license file](LICENSE).

This software is derived from [TTFH's Teardown-Converter](https://github.com/TTFH/Teardown-Converter).
