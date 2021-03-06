#!/bin/bash
# ACTION: Install clear xfce4-notify theme
# DEFAULT: y

# Check root
[ "$(id -u)" -ne 0 ] && {
	echo "Must run as root" 1>&2
	exit 1
}

base_dir="$(dirname "$(readlink -f "$0")")"

# Install packages
pacman -Sy --noconfirm libnotify xfce4-notifyd

# Create theme
mkdir -p "/usr/share/themes/clear-notify/xfce-notify-4.0/"
cp -v "$base_dir/clear_xfce-notify-4.0_gtk.css" "/usr/share/themes/clear-notify/xfce-notify-4.0/gtk.css"

for d in /etc/skel/ /home/*/; do
	# Skip dirs in /home that not are user home
	[ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue

	# Create config folders if no exists
	d="$d/.config/"
	[ ! -d "$d" ] && mkdir -v "$d" && chown -R $(stat "$d" -c %u:%g) "$d"
	d="$d/xfce4/"
	[ ! -d "$d" ] && mkdir -v "$d" && chown -R $(stat "$d" -c %u:%g) "$d"
	d="$d/xfconf/"
	[ ! -d "$d" ] && mkdir -v "$d" && chown -R $(stat "$d" -c %u:%g) "$d"
	d="$d/xfce-perchannel-xml/"
	[ ! -d "$d" ] && mkdir -v "$d" && chown -R $(stat "$d" -c %u:%g) "$d"

	f="xfce4-notifyd.xml"
	if [ ! -f "$d/$f" ]; then
		cp -v "$base_dir/$f" "$d" && chown -R $(stat "$d" -c %u:%g) "$d/$f"
	else
		sed -i '/name="theme"/s/value=".*"/value="clear-notify"/' "$f"
	fi
done
