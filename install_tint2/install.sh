#!/bin/bash
# ACTION: Install tint2 bar and themes
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && {
	echo "Must run as root" 1>&2
	exit 1
}

base_dir="$(dirname "$(readlink -f "$0")")"

# Install tint2
pacman -Sy --noconfirm tint2

# Check if laptop:
[ -f /sys/module/battery/initstate ] || [ -d /proc/acpi/battery/BAT0 ] && laptop="true"

# Check if virtualmachine:
grep -i hypervisor /proc/cpuinfo &>/dev/null && virtualmachine="true"

for d in /etc/skel/ /home/*/; do
	# Skip dirs in /home that not are user home
	[ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue

	# Create config folders if no exists
	d="$d/.config/"
	[ ! -d "$d" ] && mkdir -v "$d" && chown -R $(stat "$d" -c %u:%g) "$d"
	d="$d/tint2/"
	[ ! -d "$d" ] && mkdir -v "$d" && chown -R $(stat "$d" -c %u:%g) "$d"

	# Copy all tint2 configs
	# touch "$d/each .tint file here is autoloaded"
	cp -v "$base_dir/"*.tint_ "$d" && chown $(stat "$(dirname "$d")" -c %u:%g) "$d"/*.tint_

	[ "$laptop" ] && [ ! "$virtualmachine" ] && tint_version="_laptop"

	# Config .tints to autoload
	mv "$d/taskbar${tint_version}.tint_" "$d/taskbar${tint_version}.tint"
	mv "$d/menu.tint_" "$d/menu.tint"
done

# Copy tint2-session
f="tint2-session"
cp -v "$base_dir/$f" /usr/bin
chmod a+x "/usr/bin/$f"
