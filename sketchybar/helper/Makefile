all: helper

helper: helper.c cpu.h sketchybar.h clock.h
    clang -std=c99 -O3 -framework Foundation -framework AppKit helper.c -o helper

clean: rm -f helper

.PHONY: clean
