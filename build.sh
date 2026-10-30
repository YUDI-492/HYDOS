#!/usr/bin/env bash

set -e

echo "=========================="
echo "       HYDOS BUILD"
echo "=========================="

echo "[1/6] Compiling kernel..."
echo "[2/6] Linking kernel..."
cd HYDOSKernel
make -f  Kernel.makefile all

cd ../
#make HYDOSKernel/Kernel.makefile
    
echo "[3/6] Preparing ISO tree..."

rm -rf iso_root
mkdir -p iso_root/boot/limine
mkdir -p iso_root/EFI/BOOT


# HYDOS kernel
cp HYDOSKernel/build/kernel.elf iso_root/boot/kernel.elf

# Limine configuration
cp limine.conf iso_root/boot/limine/limine.conf


# BIOS boot files
cp limine-binary/limine-bios.sys \
   iso_root/boot/limine/

cp limine-binary/limine-bios-cd.bin \
   iso_root/boot/limine/


# UEFI boot image
cp limine-binary/limine-uefi-cd.bin \
   iso_root/boot/limine/


# x86-64 UEFI executable
cp limine-binary/BOOTX64.EFI \
   iso_root/EFI/BOOT/


echo "[4/6] Creating BIOS + UEFI hybrid ISO..."

rm -f HYDOS.iso

xorriso -as mkisofs \
    -R -r -J \
    -b boot/limine/limine-bios-cd.bin \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -hfsplus \
    -apm-block-size 2048 \
    --efi-boot boot/limine/limine-uefi-cd.bin \
    -efi-boot-part \
    --efi-boot-image \
    --protective-msdos-label \
    iso_root \
    -o HYDOS.iso


echo "[5/6] Installing Limine BIOS stage..."

./limine-binary/limine bios-install HYDOS.iso


echo "[6/6] Done."

echo
echo "HYDOS.iso created successfully."
ls -lh HYDOS.iso
