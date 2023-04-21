# Create Partition Table
parted /dev/vda -- mklabel gpt

# Create Partitions
parted /dev/vda -- mkpart primary 512MiB -8GiB
parted /dev/vda -- mkpart primary linux-swap -8GiB 100%
parted /dev/vda -- mkpart ESP fat32 1Mib 512MiB
parted /dev/vda -- set 3 esp on

# Define File System
mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda3

# Mount Partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/boot /mnt/boot/efi
swapon /dev/vda2

# Generate Nixos Config file
# nixos-generate-config --root /mnt
# cd /mnt/etc/nixos