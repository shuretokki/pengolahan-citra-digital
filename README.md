# Pengolahan Citra Digital

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="common/assets/readme-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="common/assets/readme-light.png">
  <img alt="Project Header" src="common/assets/readme-light.png" width="100%">
</picture>

Latihan dan implementasi PCD dengan C++23. Semester 4 rajin belajar.

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
meson compile -C build tugas2

# example run
./build/tugas/tugas2
```

## Tugas

| #   | Folder   | Tugas                                             |
| --- | -------- | ------------------------------------------------- |
| 1   | `tugas2` | Menampilkan citra, resolusi (M×N), gray level (L) |
| 2   | `tugas3` | Point Processing & Operasi Aritmatika-Logika      |
| 3   | `tugas4` | Histogram Processing & Spatial Filtering          |

## Tools

`OpenCV 4.13.0` `spdlog` `Clang` `Meson`

## Disclaimer

Images used in this repository are not mine and are used for educational purposes only. All copyrights belong to their respective owners.
