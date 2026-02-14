# Pengolahan Citra Digital

Latihan dan implementasi Digital Image Processing menggunakan C++23.

## Referensi

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

# single execute compile
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
