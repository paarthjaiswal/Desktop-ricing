
# 📦 Arch Linux Installation Guide (No GUI)

*This guide covers setting up Arch Linux from scratch up to a base, non-GUI system.*  
*Includes networking, partitioning, formatting, mounting, and installation steps.*

---

## 📶 1. Connect to Wi-Fi

Start the wireless prompt:

```bash
iwctl
```

Inside the `iwctl` prompt:

```bash
device list
station wlan0 get-networks
station wlan0 connect "YourWiFiName"
exit
```

To test if you're online:

```bash
ping archlinux.org
```

---

## 📦 2. Pacman Preparation

Sync packages and update keyring:

```bash
pacman -Sy
pacman -S archlinux-keyring
```

📝 `pacman -Sy` syncs the package database with the latest info from the mirror list.  
📝 `archlinux-keyring` ensures you have the latest trusted keys to verify package authenticity.

---

## 💽 3. Disk Partitioning

First, identify your disk:

```bash
lsblk
```

Then use a tool like `cfdisk` or `fdisk`:

```bash
cfdisk /dev/sdX  # Replace sdX with your drive (e.g., sda or nvme0n1)
```

### 🧩 Suggested Partition Layout

| Mount Point | Recommended Size | Filesystem | Notes                  |
|-------------|------------------|------------|-------------------------|
| `/boot`     | 512MB – 1GB      | ext4       | or EFI if dual-booting |
| `swap`      | 2–4GB (or RAM size) | swap   | Optional but recommended |
| `/`         | 15–30GB+         | ext4       | Root partition          |
| `/home`     | Rest of space    | ext4       | For user files          |

❗ Partitioning is mandatory unless you're using `archinstall` with auto-partitioning.

---

## 🧹 4. Format and Mount Partitions

After partitioning:

```bash
mkfs.ext4 /dev/sdX1    # format root (or /boot)
mkswap /dev/sdX2       # optional
swapon /dev/sdX2       # if using swap
mkfs.ext4 /dev/sdX3    # format /home if separate

mount /dev/sdX1 /mnt   # mount root
mkdir /mnt/home
mount /dev/sdX3 /mnt/home  # if separate
```

Use `lsblk` to verify:

```bash
lsblk
```

---

## 🏗️ 5. Install Base System

```bash
pacstrap -K /mnt base linux linux-firmware vim nano networkmanager
```

- `-K` skips keyring initialization if already done manually

Generate fstab:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Chroot into the new system:

```bash
arch-chroot /mnt
```

---

## ⚙️ 6. System Config (Post Chroot)

Set time zone:

```bash
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
```

Set locale:

```bash
nano /etc/locale.gen
# Uncomment your locale, e.g., en_US.UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

Set hostname:

```bash
echo "your-hostname" > /etc/hostname
```

Edit hosts file:

```bash
nano /etc/hosts
```

Add the following:

```
127.0.0.1   localhost
::1         localhost
127.0.1.1   your-hostname.localdomain your-hostname
```

Set root password:

```bash
passwd
```

Enable networking:

```bash
systemctl enable NetworkManager
```

Install bootloader (example with GRUB on BIOS):

```bash
pacman -S grub
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
```

Exit and reboot:

```bash
exit
umount -R /mnt
reboot
```

---

## 🧠 7. Optional: Using `archinstall`

Instead of manual setup, you can run:

```bash
archinstall
```

This launches the official guided installer:

- Choose your keyboard, language, timezone
- Automatically handles disk partitioning
- Lets you select base or full desktop environments

Use this if you're new or just want a fast base install with minimal input.

---

# ✅ Done!

You now have a working base Arch Linux system ready for further ricing or package setup.  
Next step: boot into your system and begin your dotfiles and rice!
