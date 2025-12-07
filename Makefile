ASM=nasm

SRC_DIR = src
BUILD_DIR = build
OS = $(shell uname)

.PHONY: all floppy_image kernel bootloader clean always

ifeq ($(OS), Darwin)
MKFS_FLOPPY = newfs_msdos -F 12 -v NBOS -S 512 -s 2880 -h 2 -T 80 $(BUILD_DIR)/main_floppy.img
else
MKFS_FLOPPY = mkfs.fat -F 12 -n NBOS $(BUILD_DIR)/main_floppy.img
endif


# ---Floppy_Image -----

floppy_image:$(BUILD_DIR)/main_floppy.img 
$(BUILD_DIR)/main_floppy.img:  kernel bootloader
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	$(MKFS_FLOPPY)
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc
	#cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/main_floppy.img
	#truncate -s 1440k $(BUILD_DIR)/main_floppy.img
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

# ---Bootloader -----

bootloader:$(BUILD_DIR)/bootloader.bin
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always


# ---Kernel -----

kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

always:
	mkdir -p $(BUILD_DIR)

#---clean -----
clean:
	rm $(BUILD_DIR)/*


