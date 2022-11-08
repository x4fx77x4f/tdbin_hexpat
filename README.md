# tdbin.hexpat
Parser written in [the Pattern Language](https://imhex.werwolv.net/docs/) for the proprietary TDBIN format used in [Teardown](https://store.steampowered.com/app/1167630/Teardown/).

## Usage
1. Install [ImHex](https://imhex.werwolv.net/).
2. Decompress your TDBIN file with `zlib-flate -uncompress < foo.bin > bar.bin` if it's a base game level in `data/bin/`. (`quicksave.bin` isn't compressed.)
3. Open your TDBIN file(s) in ImHex.
4. For each one, go to "File"->"Load pattern..."->"Browse..." and load [`tdbin.hexpat`](tdbin.hexpat).
5. Click the play button under "Console" under "Pattern editor".
6. Look through the parsed data in "Pattern Data".

## License
Copyright (c) 2022 x4fx77x4f
This software is released under the GNU General Public License version 3. The license terms can be found in [the license file](LICENSE).
This software is derived in part from [metarmask's teardown-converter](https://github.com/metarmask/teardown).
This software is derived in part from [TTFH's Teardown-Converter](https://github.com/TTFH/Teardown-Converter).
