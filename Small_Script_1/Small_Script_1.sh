#!/bin/bash
#author & index: Marcin Bajkowski & s193696
#faculty & field of study: ETI & IT, Gdańsk University of Technology, 2023
grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort -u | sed "s#.*/##" | grep "\.iso" > temporary.txt
grep "/cdlinux-" cdlinux.www.log | cut -d ' ' -f 1,7,9 | cut -d ':' -f 2 | grep "200" | sort -u | cut -d ' ' -f 2 | sed "s#.*/##" | grep "\.iso$" >> temporary.txt
sort temporary.txt | uniq -c | sort -rn > Small_Script_1.txt
rm temporary.txt
