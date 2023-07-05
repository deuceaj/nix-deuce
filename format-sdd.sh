# Create Partition Table
parted /dev/nvme0n1 -- mklabel gpt

# Create Partitions
parted /dev/nvme0n1 -- mkpart primary 512MiB -8GiB
parted /dev/nvme0n1 -- mkpart primary linux-swap -8GiB 100%
parted /dev/nvme0n1 -- mkpart ESP fat32 1Mib 512MiB
parted /dev/nvme0n1 -- set 3 esp on

# Define File System
mkfs.ext4 -L nixos /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.fat -F 32 -n boot /dev/nvme0n1p3

# Mount Partitions
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/disk/by-label/boot /mnt/boot/efi
swapon /dev/nvme0n1p2

# Generate Nixos Config file
nixos-generate-config --root /mnt
cd /mnt/etc/nixos
