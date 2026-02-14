project(
  'pcd',
  'cpp',
  version : '0.1',
  meson_version : '>= 1.3.0',
  default_options : [
    'cpp_std=c++23',
    'warning_level=3',
    'buildtype=debugoptimized',
  ]
)

add_project_arguments(
  '-DROOT="' + meson.project_source_root() + '"',
  '-Wno-c11-extensions',
  language: 'cpp')

subdir('tugas')
