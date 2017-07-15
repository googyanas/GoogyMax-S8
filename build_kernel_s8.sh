#!/bin/sh
export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-
# export CROSS_COMPILE=/home/anas/S8/sabermod/bin/aarch64-
export KCONFIG_NOTIMESTAMP=true
export ARCH=arm64
export SUBARCH=arm64

VER="\"-GoogyMax-S8_N_v$1\""
cp -f /home/anas/S8/Kernel/arch/arm64/configs/googymax-s8_defconfig /home/anas/S8/googymax-s8_defconfig
sed "s#^CONFIG_LOCALVERSION=.*#CONFIG_LOCALVERSION=$VER#" /home/anas/S8/googymax-s8_defconfig > /home/anas/S8/Kernel/arch/arm64/configs/googymax-s8_defconfig

find -name '*.ko' -exec rm -rf {} \;

rm -f /home/anas/S8/Kernel/arch/arm64/boot/Image*.*
rm -f /home/anas/S8/Kernel/arch/arm64/boot/.Image*.*
make googymax-s8_defconfig || exit 1

make -j4 || exit 1

cp -f /home/anas/S8/Kernel/arch/arm64/boot/Image /home/anas/S8/Out/gmax/kernel
./tools/dtbtool -o /home/anas/S8/Out/gmax/dt.img -s 2048 -p ./scripts/dtc/ arch/arm64/boot/dts/exynos/

cd /home/anas/S8/Out
./packimg gmax /home/anas/S8/Release/boot.img
echo SEANDROIDENFORCE >> boot.img

cd /home/anas/S8/Release
rm -f /home/anas/S8/GoogyMax-S8_Kernel_N_v${1}.zip
zip -r ../GoogyMax-S8_Kernel_N_v${1}.zip .

adb push /home/anas/S8/GoogyMax-S8_Kernel_N_v${1}.zip /sdcard/GoogyMax-S8_Kernel_N_v${1}.zip

adb kill-server

echo "GoogyMax-S8_Kernel_N_v${1}.zip READY !"
