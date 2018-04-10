#!/bin/bash

#############################################
# 	Author: Somesh K Prajapati	    #
#############################################

out_file_path=/home/somesh/sysinfo.out

echo -e "**************************************************************************************************" >> $out_file_path
echo -e "******************************************* SYSTEM INFO ******************************************" >> $out_file_path
echo -e "**************************************************************************************************\n" >> $out_file_path

echo -e "\n\n========================================= HOST INFO ==========================================\n" >> $out_file_path
echo -e "\tHostname:\t"`hostname` >> $out_file_path

echo -e "\n\n========================================== OS INFO ===========================================\n" >> $out_file_path
echo -e "\tOS Info:\t"`cat /etc/system-release` >> $out_file_path

echo -e "\n\n======================================== KERNEL INFO =========================================\n" >> $out_file_path
echo -e "\tKernel Version:\t"`uname -r` >> $out_file_path

echo -e "\n\n========================================= CPU INFO ===========================================\n" >> $out_file_path
echo -e "\tTotal Processor:\t"`grep -c 'processor' /proc/cpuinfo` >> $out_file_path
echo -e "\tCPU Processor Model:\t"`awk -F':' '/^model name/ { print $2 }' /proc/cpuinfo` >> $out_file_path
echo -e "\tCPU Processor Speed:\t"`awk -F':' '/^cpu MHz/ { print $2 }' /proc/cpuinfo` >> $out_file_path
echo -e "\tCPU Cache Size:\t"`awk -F':' '/^cache size/ { print $2 }' /proc/cpuinfo`  >> $out_file_path

echo -e "\n\n========================================== RAM INFO ==========================================\n" >> $out_file_path
echo -e "\tMemory(RAM) Info:\t"`free -mht| awk '/Mem/{print " \tTotal: " $2 "\tUsed: " $3 "\tFree: " $4}'`  >> $out_file_path
echo -e "\tSwap Memory Info:\t"`free -mht| awk '/Swap/{print " \t\tTotal: " $2 "\tUsed: " $3 "\tFree: " $4}'` >> $out_file_path

echo -e "\n\n========================================== IP INFO ===========================================\n" >> $out_file_path
ifconfig >> $out_file_path

echo -e "\n\n====================================== ROUTE TABLE INFO ======================================\n" >> $out_file_path
route -n >> $out_file_path

echo -e "\n\n====================================== MOUNT POINT INFO ======================================\n" >> $out_file_path
cat /etc/fstab|grep -v "#" >> $out_file_path

echo -e "\n\n==================================== DISK PARTATION INFO =====================================\n" >> $out_file_path
df -h >> $out_file_path

echo -e "\n\n==================================== PHYSICAL VOLUME INFO ====================================\n" >> $out_file_path
pvs >> $out_file_path

echo -e "\n\n===================================== VOLUME GROUP INFO ======================================\n" >> $out_file_path
vgs >> $out_file_path

echo -e "\n\n===================================== LOGICAL VOLUME INFO ====================================\n" >> $out_file_path
lvs >> $out_file_path

echo -e "\n\n==================================== RUNNING SERVICE INFO ====================================\n" >> $out_file_path
systemctl list-units | grep running|sort >> $out_file_path

echo -e "\n\n==================================== TOTAL RUNNING SERVICE ===================================\n" >> $out_file_path
echo -e "\tTotal Running service:\t"`systemctl list-units | grep running|sort| wc -l` >> $out_file_path

echo -e "\n\n========================================= GRUB INFO ==========================================\n" >> $out_file_path
cat /etc/default/grub >> $out_file_path

echo -e "\n\n========================================= BOOT INFO ==========================================\n" >> $out_file_path
ls -l /boot|grep -v total >> $out_file_path

echo -e "\n\n====================================== ACTIVE USER INFO ======================================\n" >> $out_file_path
echo -e "\tCurrent Active User:\t"`w | cut -d ' ' -f 1 | grep -v USER | sort -u` >> $out_file_path
