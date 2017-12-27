#!/bin/bash

var=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s)  
 
while read -r line; do
    IFS=$'\t' read -r -a array <<< "$line"
    sepind="$(echo $line |awk -F '\n' -v s=: '{print index($1,s)}')"
    endofsig="$(expr $sepind - 4)"
    if [ 0 -le $endofsig ]; then
    	substr=${line:0:$endofsig}
    else
    	substr=0;
    fi
    mainarray+=("$substr")
    begofnum="$(expr $sepind + 15)"
    substr=${line:begofnum:3}
    mainarray+=("$substr")
done <<< "$var"

max1=-1000
max1ind=1
max2=-1000
max2ind=1
max3=-1000
max3ind=1
for ((j=2;j<${#mainarray[@]};j+=2))
do
	if [ $max1 -le ${mainarray[j+1]} ] && [ ${mainarray[j+1]} != 0 ]; then
		max1=${mainarray[j+1]}
		max1ind=`expr $j + 1`
	fi	
done

for ((k=2;k<${#mainarray[@]};k+=2))
do
	if [ $max2 -le ${mainarray[k+1]} ] && [ ${mainarray[k+1]} != 0 ] && [ $k != `expr $max1ind - 1` ]; then
		max2=${mainarray[k+1]}
		max2ind=`expr $k + 1`
	fi	
done

for ((m=2;m<${#mainarray[@]};m+=2))
do
	if [ $max3 -le ${mainarray[m+1]} ] && [ ${mainarray[m+1]} != 0 ] && [ $m != `expr $max1ind - 1` ] && [ $m != `expr $max2ind - 1` ]; then
		max3=${mainarray[m+1]}
		max3ind=`expr $m + 1`
	fi	
done

echo "BEST WIFI #1 IS: ${mainarray[max1ind-1]} --> ${mainarray[max1ind]}"
echo "BEST WIFI #2 IS: ${mainarray[max2ind-1]} --> ${mainarray[max2ind]}"
echo "BEST WIFI #3 IS: ${mainarray[max3ind-1]} --> ${mainarray[max3ind]}"



