#!/bin/bash

plat=linux
arch=$plat/`uname -m`;
aik="${BASH_SOURCE:-$0}";
aik="$(dirname "$(readlink -f "$aik")")";
bin="$aik/bin";


usage()
{
     echo -e "Usage: $0 page_size  KERNEL_OUT  partition_size  partition_name\n"
	 echo -e "       $0 4096  KERNEL_OUT  0x0800000  dtbo\n"
     exit
}

if [ ! -n "$1" ] ;then
echo -e "no page_size"
usage
else
page_size=$1
fi

if [ ! -n "$2" ] ;then
echo -e "no KERNEL_OUT"
usage
else
INPUT_FILE=`readlink -f $2`
fi

if [ ! -n "$3" ] ;then
echo "no partition_size"
usage
fi

if [ ! -n "$4" ] ;then
echo "No partition_name, Default dtbo"
dtbo_name=dtbo
else
dtbo_name=$4
fi


$bin/$arch/mkdtimg create dtbo.img --page_size=$1 $(find $INPUT_FILE -iname "*.dtbo")
chmod a+x dtbo.img
$bin/$arch/avbtool add_hash_footer --image dtbo.img --partition_size $3 --partition_name $dtbo_name

dtboimage=`readlink -f dtbo.img`

echo -e "OUTFILE = $dtboimage"