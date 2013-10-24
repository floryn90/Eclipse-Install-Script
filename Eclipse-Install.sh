#!/bin/bash

MACHINE_TYPE=`uname -m`



# Checks that the script is running as root, if not
# it will ask for permissions
# Source: http://unix.stackexchange.com/a/28796
if (($EUID != 0)); then
  if [[ -t 1 ]]; then
		sudo "$0" "$@"
	else
		exec 1>output_file
		gksu "$0 $@"
	fi
 
	exit
fi



echo "Downloading Eclipse"

cd /tmp

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
	wget http://cdn.mirror.garr.it/mirror3/mirrors/eclipse//technology/epp/downloads/release/kepler/SR1/eclipse-standard-kepler-SR1-linux-gtk-x86_64.tar.gz -O Eclipse.tar.gz
else
	wget http://cdn.mirror.garr.it/mirror3/mirrors/eclipse//technology/epp/downloads/release/kepler/SR1/eclipse-standard-kepler-SR1-linux-gtk.tar.gz -O Eclipse.tar.gz
fi



# Create the /opt dir if it doesn't exist
if [ ! -d /opt/ ]; then
	mkdir /opt/
fi



echo "Extracting Eclipse Kepler to /opt"

#unzip -q AptanaStudio.zip -d /opt/
tar zxf Eclipse.tar.gz -C /opt/



echo "Adding Eclipse Kepler desktop entry"

# Create the /usr/local/share/icons dir if it doesn't exist
if [ ! -d /usr/local/share/icons/ ]; then
	mkdir /usr/local/share/icons/
fi

# Fix for large icon problem
cp /opt/eclipse/icon.xpm /usr/local/share/icons/eclipse.xpm

echo "[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=Eclipse Kepler
GenericName=Integrated Development Environment
Comment=Eclipse Kepler Integrated Development Environment
Exec=/opt/eclipse/Eclispe %F
TryExec=/opt/eclipse/Eclipse
Icon=eclipse
StartupNotify=true
StartupWMClass=\"Eclipse\"
Terminal=false
Type=Application
MimeType=text/xml;application/xhtml+xml;application/x-javascript;application/x-php;application/x-java;text/x-javascript;text/html;text/plain
Categories=GNOME;Development;IDE;" >> /tmp/SC-Eclipse.desktop
xdg-desktop-menu install /tmp/SC-Eclipse.desktop

echo "Eclipse Kepler has been installed"