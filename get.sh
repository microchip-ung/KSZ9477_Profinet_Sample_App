# Pre-condition file tree:
#
# -+- my_ksz - get.sh
#  | 
#  +- ksz-profinet-class-a-sample-application.tar.gz
#
# i.e. you create a folder 'my_ksz' where this file 'get.sh' shall be put.
# Also the  ksz-profinet-class-a-sample-application.tar.gz must exist as shown.
# Then say:
# $ cd my_ksz
# $ . get.sh
#
# After this we will have the tree
#
# -+- my_ksz -+- get.sh
#  |          +- EVB-KSZ9477 - ...
#  +- profinet-package - 
#  +- ksz-profinet-class-a-sample-application.tar.gz
#
# Where EVB-KSZ9477 has been git-cloned, and version tag v1.2.1 has been checked out.
# Then the code has been patched with the ksz-profinet code, and the shell is in the
# folder where you can just say 'make' to build the thing.
#
###

# (1) --- If EVB-KSZ9477 exist we already have run the git clone command
#
if [ ! -d EVB-KSZ9477 ]; then
 git clone https://github.com/Microchip-Ethernet/EVB-KSZ9477.git
 cd EVB-KSZ9477
 git checkout v1.2.1
 cd ..
fi

# (2) --- If the ../profinet-package exist we assume the profinet code
#         has already been patched in.
#         Assume ksz-profinet-class-a-sample-application.tar.gz is in ../
#
if [ ! -d ../profinet-package ]; then
    mkdir -p ../profinet-package
    tar xzf ../ksz-profinet-class-a-sample-application.tar.gz -C ../profinet-package

    mv ../profinet-package/ksz_linuxpnet EVB-KSZ9477/KSZ/Atmel_SOC_SAMA5D3/buildroot/package/microchip
    mv ../profinet-package/pnetapp       EVB-KSZ9477/KSZ/app_utils
    echo "Adding ksz_linuxpnet to microchip package"
    echo "source \"package/microchip/ksz_linuxpnet/Config.in\"" >>  EVB-KSZ9477/KSZ/Atmel_SOC_SAMA5D3/buildroot/package/microchip/Config.in
#    exit
fi

# (3) --- Move on to build
#
cd EVB-KSZ9477/KSZ
export KSZ_HOME=`pwd`
cd Atmel_SOC_SAMA5D3/buildroot
make atmel_sama5d3_xplained_ksz9897_defconfig

echo "Now run make to build"

