#!/bin/bash

#############################################
# 	Author: Somesh K Prajapati	    #
#############################################

script_path=/home/somesh
files_path=/home/somesh/pdf_files
dest_dir=/home/somesh/out_pdf_file

remote_user=somesh
remote_host=192.168.20.27

# Count the total no of pdf files inside folder
min=1
max=`find $files_path -type f -name "*.pdf" | wc -l`
temp=`expr $max % 10` 
no_of_range=`expr $max / 10`

if [ $temp -eq 0 ]
then 
   no_of_range=$no_of_range
else
   no_of_range=`echo "($no_of_range + 1)" | bc`
fi

# Calculate the range length  
length_of_range=`echo "($max - $min + 1)/$no_of_range" | bc`

# Create the range file
for i in $(seq 1 $no_of_range)
do
	start_range=`echo "($length_of_range * ($i-1) + $min)" | bc`
	end_range=`echo "($start_range + $length_of_range - 1)" | bc`
	echo "$start_range,$end_range" >> $script_path/range_file.dat
done

if [ $temp -ne 0 ]
then 
	last=$(sed -n '$p' $script_path/range_file.dat | awk 'BEGIN{FS=","} {print $2}')
	last_start_range=`echo "($last + 1)" | bc`
	last_end_range=`echo "($max + 1)" | bc`
	echo "$last_start_range,$last_end_range" >> $script_path/range_file.dat
fi

for range in `cat $script_path/range_file.dat`
do
	echo "*********************************************"
	echo "Start Copying for range: "$range
	find $files_path -maxdepth 1 -type f -name "*.pdf" | sed -n -e $range"p" | xargs -I {} scp {} $remote_user@$remote_host:$dest_dir
	echo "Files Copied successfully for range: "$range
	echo "*********************************************"
done

