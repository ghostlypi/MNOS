# Makefile for MNOS

# Directories
SRC_DIR = src
BOOT_DIR = boot
INCLUDE_DIR = include
BUILD_DIR = build

# Compiler and flags
CC = smlrcc
AS = nasm
CCFLAGS = -SI$(INCLUDE_DIR) -flat16 -origin 0x8000

# Source files and object files
SRC_FILES := $(wildcard $(SRC_DIR)/**/*.c $(SRC_DIR)/*.c)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRC_FILES))

# Build targets
all: kern.sys

kern.sys: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kern.bin
	cat $^ > $@

$(BUILD_DIR)/boot.bin: $(BOOT_DIR)/boot.asm
	$(AS) -fbin $< -o $@

$(BUILD_DIR)/kern.bin: $(SRC_FILES)
	$(CC) $(CCFLAGS) $^ -o $@

# $(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
# 	$(CC) $(CCFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/* kern.sys

run: kern.sys
	qemu-system-x86_64 -fda kern.sys

.PHONY: all clean qemu
