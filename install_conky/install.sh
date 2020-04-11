#!/bin/bash
# ACTION: Install theme Conky with new theme
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && {
	echo "Must run as root" 1>&2
	exit 1
}

base_dir="$(dirname "$(readlink -f "$0")")"

# Install conky
pacman -Sy --noconfirm conky

for d in /etc/skel/ /home/*/; do
	# Skip dirs in /home that not are user home
	[ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue

	# Create config folders if no exists
	d="$d/.config/"
	[ ! -d "$d" ] && mkdir -v "$d" && chown -R $(stat "$(dirname "$d")" -c %u:%g) "$d"
	d="$d/conky/"
	[ ! -d "$d" ] && mkdir -v "$d" && chown -R $(stat "$(dirname "$d")" -c %u:%g) "$d"

	# Copy all conky configs
	# touch "$d/each .conkyrc file here is autoloaded"
	cp -v "$base_dir/"*.conkyrc "$d" && chown $(stat "$(dirname "$d")" -c %u:%g) "$d"/*.conkyrc
done

# Show /home in conky if /home has mounted in separated partition
if mount | grep -q "on /home[[:blank:]]"; then
	for f in /etc/skel/.config/conky/*.conkyrc /home/*/.config/conky/*.conkyrc; do
		sed -i '/Home usage/s/^#//g' "$f"
	done
fi

# Copy conky-session
f="conky-session"
cp -v "$base_dir/$f" /usr/bin
chmod a+x "/usr/bin/$f"
