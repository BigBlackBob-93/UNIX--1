#! /usr/bin/bash -e

trap del_temp_dir EXIT QUIT TERM INT HUP PIPE

function del_temp_dir {
	cd ../ 
	local err=$?
	trap - EXIT
    
	if [ -d "$dir_name" ]; then
    		rm -f -d $dir_name
    		echo "OK: temporary directory was deleted"
	fi

	exit $err
}

if [ "$#" -lt 1 ]; then
	echo "ERROR: source file name wasn't found"
	exit 1
fi

dir_name=`mktemp -d authentic+XXXXXX`
mv $1 $dir_name
cd $dir_name
file_name=`awk '/\/\output:/{print $2}' $1` #finding the output file name in the source file

if [ -z $file_name ]; then
	echo "ERROR: execution file name wasn't found"
	mv $1 ../
	cd ../
	rmdir $dir_name
	exit 1
fi

g++ -Wall -o $file_name $1
./$file_name
mv $1 ../
mv $file_name ../
