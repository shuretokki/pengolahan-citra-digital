# build system
setup:
	meson setup build --wipe

compile:
	meson compile -C build

clean:
	rm -rf build

# compile and run tugas 2
run-2: compile
	./build/tugas/tugas2

# compile and run tugas 3
run-3: compile
	./build/tugas/tugas3

# compile and run tugas 4
run-4: compile
	./build/tugas/tugas4

# compile and run tugas 5
run-5: compile
	./build/tugas/tugas5

watch-3 target="laporan":
    typst-live tugas/tugas3/{{target}}.typ -- --root .

# watch laporan tugas 4
watch-4 target="laporan":
    typst-live tugas/tugas4/{{target}}.typ -- --root .

# watch laporan tugas 4
watch-5 target="laporan":
    typst-live tugas/tugas5/{{target}}.typ -- --root .

# watch readme.typ
watch-readme:
	typst-live README.typ

# generate readme previews
build-readme:
	typst compile --input theme=light README.typ --root . --ppi 150 common/assets/readme-light.png
	typst compile --input theme=dark README.typ --root . --ppi 150 common/assets/readme-dark.png