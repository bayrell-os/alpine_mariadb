if [ ! -z $WWW_UID ]; then
	sed -i "s|800|$WWW_UID|g" /etc/passwd
fi
if [ ! -z $WWW_GID ]; then
	sed -i "s|800|$WWW_GID|g" /etc/group
fi