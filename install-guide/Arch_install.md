<h1 align="center">📦 Arch Linux Installation Guide (No GUI)</h1>

<p align="center">
  This guide covers setting up Arch Linux from scratch up to a base, non-GUI system. <br/>
  Includes networking, partitioning, formatting, mounting, and installation steps.
</p>

<hr/>

<h2>📶 1. Connect to Wi-Fi</h2>

<pre><code>iwctl</code></pre>

Inside the iwctl prompt:

```bash
device list
station wlan0 get-networks
station wlan0 connect "YourWiFiName"

Use exit to quit iwctl.

To test if you're online:

ping archlinux.org

<h2>📦 2. Pacman Preparation</h2>

Sync packages and update keyring:

pacman -Sy
pacman -S archlinux-keyring

    📝 pacman -Sy syncs the package database with the latest info from the mirror list.
    📝 archlinux-keyring ensures you have the latest trusted keys to verify package authenticity.

<h2>💽 3. Disk Partitioning</h2>

First, identify your disk:

lsblk

Then use a tool like cfdisk or fdisk:

cfdisk /dev/sdX  # Replace sdX with your drive (e.g., sda or nvme0n1)

🧩 Suggested Partition Layout
Mount Point	Recommended Size	Filesystem	Notes
/boot	512MB – 1GB	ext4	or EFI if dual-booting
swap	2–4GB (or same as RAM)	swap	optional but recommended
/	15–30GB+	ext4	root partition
/home	rest of space	ext4	for user files

    ❗ Partitioning is mandatory unless you're using archinstall with auto-partitioning.

<h2>🧹 4. Format and Mount Partitions</h2>

After partitioning:

mkfs.ext4 /dev/sdX1    # format root (or boot)
mkswap /dev/sdX2       # optional
swapon /dev/sdX2       # if using swap
mkfs.ext4 /dev/sdX3    # format /home if separate

mount /dev/sdX1 /mnt   # mount root
mkdir /mnt/home
mount /dev/sdX3 /mnt/home  # if separate

Use lsblk to verify everything:

lsblk

<h2>🏗️ 5. Install Base System</h2>

pacstrap -K /mnt base linux linux-firmware vim nano networkmanager

    -K skips keyring initialization if already done manually

Generate fstab:

genfstab -U /mnt >> /mnt/etc/fstab

Chroot into the new system:

arch-chroot /mnt

<h2>⚙️ 6. System Config (Post Chroot)</h2>

Set time zone:

ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

Set locale:

nano /etc/locale.gen
# Uncomment your locale, e.g., en_US.UTF-8
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

Set hostname:

echo "your-hostname" > /etc/hostname

Hosts file:

nano /etc/hosts

# Add these:
127.0.0.1   localhost
::1         localhost
127.0.1.1   your-hostname.localdomain your-hostname

Set root password:

passwd

Enable networking:

systemctl enable NetworkManager

Install bootloader (example with GRUB on BIOS):

pacman -S grub
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg

Exit and reboot:

exit
umount -R /mnt
reboot

<h2>🧠 7. Optional: Using <code>archinstall</code></h2>

Instead of manual setup, you can run:

archinstall

This launches an official guided installer:

    Choose your keyboard, language, timezone

    Automatically handles disk partitioning

    Lets you select base or full desktop environments

    Use this if you're new or just want a fast base install with minimal input.

<h2 align="center">✅ Done!</h2> <p align="center"> You now have a working base Arch Linux system ready for further ricing or package setup. <br/> Next step: boot into your system and begin your dotfiles and rice! </p> ```