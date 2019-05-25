#!/bin/bash

# 1) Display the top 10 IPs making the most requests, display the IP address and number of requests made
awk -F" " '{print $1}' access_log | sort | uniq -c | sort -nr|head -10 > most_request.out

# 2) Top 10 IPs, show the top 5 pages requested and the number of requests for each
awk -F" " '{print $2}' most_request.out > ip.out
for line in `cat ip.out`
do
	grep $line access_log |head -5 > "$line".out
done

# 3) Percentage of unsuccessful requests
total_req=`cat access_log|wc -l`
unsuccess=`awk -F" " '{ if ($9 != 200) { print $9} }' access_log|wc -l`

per=$(((unsuccess * 100)/total_req))

echo "The total percentage of unsuccessfull request: " $per
