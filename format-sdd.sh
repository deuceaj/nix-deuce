# Create Partition Table
parted /dev/sda -- mklabel gpt

# Create Partitions
parted /dev/sda -- mkpart primary 512MiB -8GiB
parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
parted /dev/sda -- mkpart ESP fat32 1Mib 512MiB
parted /dev/sda -- set 3 esp on

# Define File System
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

# Mount Partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/boot /mnt/boot/efi
swapon /dev/sda2

# Generate Nixos Config file
nixos-generate-config --root /mnt
cd /mnt/etc/nixos