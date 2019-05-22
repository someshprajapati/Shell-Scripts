#!/bin/bash

##############################################################################################
# Author: Somesh K Prajapati																 #
# -------------------------------------------------------------------------------------------#									
# To run use: bash ./log_file_analysis.sh search_string						                 #
##############################################################################################
# example: bash ./log_file_analysis.sh logout          							             #
##############################################################################################

input_file_path=/home/devops
output_file_path=/home/devops

# Function to convert time into seconds
ts_get_sec()
{
    read -r h m s <<< $(echo $1 | tr ':' ' ' )
    echo $(((h*60*60)+(m*60)+s))
}

# Function to convert time into PST (Pacific Standard Time) for first column in log file
convert_time_pst()
{
	grep -rw ${1} $input_file_path/frontend-service.log | sed 's/ /|/g' > $input_file_path/temp.out
	for line in `cat $input_file_path/temp.out`;
	do
		temp=`echo $line|awk -F"|" '{print $1 " " $2 " " $3}'`
		first=`date --date="TZ=\"PST\" ${temp}"|cut -d" " -f2,3,4`
		second=`echo $line|awk -F"|" '{$1=$2=$3=""; print $0}'`
		echo $first $second >> $output_file_path/final.out
	done
}

# Function to count string occurance and average time between all occurance
count_string_occurrences()
{
    input_string=${1}
    echo "count_string_occurrences function, input = ${input_string}"
    count=`grep -rw ${1} $input_file_path/frontend-service.log | wc -l`
    echo "Count of input String = ${count}"

    targets=($(grep -rw ${input_string} $input_file_path/frontend-service.log | awk -F ' ' '{print $3}'))
    length=${#targets[@]}
    echo "Length = ${length}"
	
	total=0

    for ((i = 0; i != length-1; i++)); 
	do
        next_index=$((i + 1))
        if [ ${next_index} -le ${length} ]; then
            #echo "Loop count = $i, next_index= ${next_index}"
            #echo "target $i: '${targets[i]}'"
            #echo "target $next_index: '${targets[next_index]}'"

            START=$(ts_get_sec ${targets[i]})
            STOP=$(ts_get_sec ${targets[next_index]})
            DIFF=$((STOP-START))

			total=$((total+DIFF))
			
            #echo "$((DIFF/60))m $((DIFF%60))s"

        else
            echo "Index incorrect."
        fi
    done
	echo "The total time taken by each occurance of string: "$total
	avg_time=$((total/length))
	echo "The total average time taken by each occurance of string: $((avg_time/60))m $((avg_time%60))s"
}

# Main body of script starts here
echo ++++++--------++++++++++----------++++++++++++-----------++++++++++++-----------++++++++++++>> $output_file_path/log_file_analysis.log
echo ++++++--------++++++++++  START SCRIPT log_file_analysis.sh    ++++++-----------++++++++++++>> $output_file_path/log_file_analysis.log
echo "     					        START PROCESS AT                     `date +%Y:%m:%d-%H:%M`" >> $output_file_path/log_file_analysis.log
echo ++++++--------++++++++++----------++++++++++++-----------++++++++++++-----------++++++++++++>> $output_file_path/log_file_analysis.log

count_string_occurrences $1
convert_time_pst $1

echo ++++++--------++++++++++----------++++++++++++-----------++++++++++++-----------++++++++++++>> $output_file_path/log_file_analysis.log
echo ++++++--------++++++++++    END SCRIPT log_file_analysis.sh    ++++++-----------++++++++++++>> $output_file_path/log_file_analysis.log
echo "     					        END PROCESS AT                       `date +%Y:%m:%d-%H:%M`" >> $output_file_path/log_file_analysis.log
echo ++++++--------++++++++++----------++++++++++++-----------++++++++++++-----------++++++++++++>> $output_file_path/log_file_analysis.log

