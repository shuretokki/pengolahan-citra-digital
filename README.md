# Pengolahan Citra Digital

Digital Image Processing exercises and implementations in C++23.

## Reference

Gonzalez, R. C., & Woods, R. E. (2018). *Digital Image Processing* (4th ed.). Pearson.

## Setup

```bash
meson setup build

# clean build
meson setup build --wipe
```

### Optional
```bash
direnv allow

# refresh dependencies
direnv reload
```

## Compile

```bash
# compile all
meson compile -C build

# single exercise compile
meson compile -C build imageinfo

# example run
./build/exercises/imageinfo
```

## Tugas

| #   | Folder      | Tugas                                             |
| --- | ----------- | ------------------------------------------------- |
| 1   | `imageinfo` | Menampilkan citra, resolusi (M×N), gray level (L) |

## Tools

`OpenCV 4.13.0` `spdlog` `Clang` `Meson`

## Disclaimer

Images used in this repository are not mine and are used for educational purposes only. All copyrights belong to their respective owners.