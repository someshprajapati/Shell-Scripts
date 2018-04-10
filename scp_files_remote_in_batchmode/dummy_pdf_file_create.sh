#!/bin/bash

#############################################
#	Author: Somesh K Prajapati          #
#############################################

# Create 150 dummy pdf files, each 1GB in size

files_path=/home/somesh/pdf_files

for i in {1..150}
do
	fallocate -l 1G $files_path/$i.pdf
done
