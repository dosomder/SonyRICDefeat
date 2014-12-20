#!/sbin/sh

system=$1

echo "#!/$system/bin/sh" > /tmp/mount.sh
echo 'mod_loaded=`lsmod | grep wp_mod`' >> /tmp/mount.sh
echo 'if [ "$mod_loaded" = "" ]; then' >> /tmp/mount.sh
echo "	insmod /$system/lib/modules/wp_mod.ko" >> /tmp/mount.sh
echo "fi" >> /tmp/mount.sh
echo "/$system/bin/stock/mount \"\$@\"" >> /tmp/mount.sh

if [ ! -f /$system/bin/stock/mount ]
then
	echo "Stock mount does not exist. Creating dir and link"
	mkdir /$system/bin/stock
	chmod 755 /$system/bin/stock
	ln -s /$system/bin/toolbox /$system/bin/stock/mount
fi
rm /$system/bin/mount
cp /tmp/mount.sh /$system/bin/mount
chmod 755 /$system/bin/mount

echo "Installing of mount.sh finished"
