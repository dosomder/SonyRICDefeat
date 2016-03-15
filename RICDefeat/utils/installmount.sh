#!/sbin/sh

if [ ! -f /tmp/wp_mod.ko ]; then
	echo "Error patching kernel module. File not found."
	exit 1
fi

if [ ! -f /tmp/busybox ]; then
	echo "Error: busybox not found"
	exit 1
fi

system=`ls / | grep -i "system"`
/tmp/busybox mount /$system
/tmp/busybox mount /dev/block/platform/msm_sdcc.1/by-name/$system /$system

if [ -f /tmp/modulecrcpatch ]; then
	for f in /system/lib/modules/*.ko; do
		/tmp/modulecrcpatch $f /tmp/wp_mod.ko
	done
fi

cp /tmp/wp_mod.ko /$system/lib/modules/wp_mod.ko
chmod 644 /$system/lib/modules/wp_mod.ko

echo "#!/$system/bin/sh" > /tmp/mount.sh
echo 'mod_loaded=`lsmod | grep wp_mod`' >> /tmp/mount.sh
echo 'if [ "$mod_loaded" = "" ]; then' >> /tmp/mount.sh
echo "	if [ -f /$system/lib/modules/wp_mod.ko ]; then" >> /tmp/mount.sh
echo "		insmod /$system/lib/modules/wp_mod.ko" >> /tmp/mount.sh
echo "	else" >> /tmp/mount.sh
echo "		insmod /data/local/tmp/wp_mod.ko" >> /tmp/mount.sh
echo "	fi" >> /tmp/mount.sh
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
