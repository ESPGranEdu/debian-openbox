#!/bin/bash
# ACTION: Configure keyboard according to your country
# DEFAULT: y

# Check root
[ $(id -u) != 0 ] && {
    echo "Must run as root"
    exit 1
}
# Install dependencies
pacman -Sy --noconfirm jq

# Declare countries with his layout
declare -A layouts
layouts[USA]="us"
layouts[Andorra]="ad"
layouts[Afghanistan]="af"
layouts[Arabic]="ara"
layouts[Albania]="al"
layouts[Armenia]="am"
layouts[Azerbaijan]="az"
layouts[Belarus]="by"
layouts[Belgium]="be"
layouts[Bangladesh]="bd"
layouts[India]="in"
layouts[Bosnia]="ba"
layouts[Brazil]="br"
layouts[Bulgaria]="bg"
layouts[Morocco]="ma"
layouts[Myanmar]="mm"
layouts[Canada]="ca"
layouts[Congo]="cd"
layouts[China]="cn"
layouts[Croatia]="hr"
layouts[Czechia]="cz"
layouts[Denmark]="dk"
layouts[Netherlands]="nl"
layouts[Bhutan]="bt"
layouts[Estonia]="ee"
layouts[Iran]="ir"
layouts[Iraq]="iq"
layouts[Faroe]="fo"
layouts[Finland]="fi"
layouts[France]="fr"
layouts[Ghana]="gh"
layouts[Guinea]="gn"
layouts[Georgia]="ge"
layouts[Germany]="de"
layouts[Greece]="gr"
layouts[Hungary]="hu"
layouts[Iceland]="is"
layouts[Israel]="il"
layouts[Italy]="it"
layouts[Japan]="jp"
layouts[Kyrgyzstan]="kg"
layouts[Cambodia]="kh"
layouts[Kazakhstan]="kz"
layouts[Laos]="la"
layouts[Latin]="latam"
layouts[Lithuania]="lt"
layouts[Latvia]="lv"
layouts[Maori]="mao"
layouts[Montenegro]="me"
layouts[Macedonia]="mk"
layouts[Malta]="mt"
layouts[Mongolia]="mn"
layouts[Norway]="no"
layouts[Poland]="pl"
layouts[Portugal]="pt"
layouts[Romania]="ro"
layouts[Russia]="ru"
layouts[Serbia]="rs"
layouts[Slovenia]="si"
layouts[Slovakia]="sk"
layouts[Spain]="es"
layouts[Sweden]="se"
layouts[Switzerland]="ch"
layouts[Syria]="sy"
layouts[Tajikistan]="tj"
layouts[Sri]="lk"
layouts[Thailand]="th"
layouts[Turkey]="tr"
layouts[Taiwan]="tw"
layouts[Ukraine]="ua"
layouts[United]="gb"
layouts[Uzbekistan]="uz"
layouts[Vietnam]="vn"
layouts[Korea]="kr"
layouts[Japan]="nec_vndr/jp"
layouts[Ireland]="ie"
layouts[Pakistan]="pk"
layouts[Maldives]="mv"
layouts[South]="za"
layouts[Esperanto]="epo"
layouts[Nepal]="np"
layouts[Nigeria]="ng"
layouts[Ethiopia]="et"
layouts[Senegal]="sn"
layouts[Braille]="brai"
layouts[Turkmenistan]="tm"
layouts[Mali]="ml"
layouts[Tanzania]="tz"

# Get country based on geolocation
country="$(curl -s https://ipvigilante.com/$(curl -s https://ipinfo.io/ip) | jq '.data.country_name' | sed 's/\"//g')"
kb_layout="${layouts[$country]}"

# Display Country
echo "You're country is -> $country"
echo "You're keyboard layout will be -> $kb_layout"

# Configure keyboard
sed -i "/XkbOptions/a/ \tOption \"XkbLayout\" \"$kb_layout\"" /etc/X11/xorg.conf.d/00-keyboard.conf
sed -i 's/\///' /etc/X11/xorg.conf.d/00-keyboard.conf # Delete no sense /