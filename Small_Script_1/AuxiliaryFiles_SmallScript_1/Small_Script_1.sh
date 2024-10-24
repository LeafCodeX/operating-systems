#!/bin/bash
#author & index: Marcin Bajkowski & s193696
#faculty & field of study: ETI & IT, Gdańsk University of Technology, 2023

# ORIGINAL !!! - POMIJA WYJĄTKI, BIERZE TYLKO "200"
grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort -u | sed "s#.*/##" | grep "\.iso" > temporary.txt
grep "/cdlinux-" cdlinux.www.log | cut -d ' ' -f 1,7,9 | cut -d ':' -f 2 | grep "200" | sort -u | cut -d ' ' -f 2 | sed "s#.*/##" | grep "\.iso$" >> temporary.txt
sort temporary.txt | uniq -c | sort -rn > Small_Script_1.0.txt
rm temporary.txt | open Small_Script_1.0.txt

# ORIGINAL - POMIJA WYJĄTKI, BIERZE WSZYSTKO
#grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort -u | sed "s#.*/##" | grep "\.iso" > temporary.txt
#grep "/cdlinux-" cdlinux.www.log | cut -d ' ' -f 1,7,9 | cut -d ':' -f 2 | grep "200" | sort -u | cut -d ' ' -f 2 | sed "s#.*/##" | grep "\.iso$" >> temporary.txt
#grep "/cdlinux-" cdlinux.www.log | cut -d ' ' -f 1,7 | cut -d ':' -f 2 | sort -u | cut -d ' ' -f 2 | sed "s#.*/##" | grep "\.iso$" >> temporary.txt
#sort temporary.txt | uniq -c | sort -rn > Small_Script_1.1.txt
#rm temporary.txt | open Small_Script_1.1.txt

# ORIGINAL 1 - POMIJA WYJĄTKI
#grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort -u | sed "s#.*/##" | grep "\.iso" > temporary.txt
#sort cdlinux.www.log | cut -d ' ' -f 1,7,9 | cut -d ':' -f 2 | grep "200" | sort -u | cut -d ' ' -f 2 | sed "s#.*/##" | grep "\.iso$" >> temporary.txt
#grep "/cdlinux-" cdlinux.www.log | cut -d ' ' -f 1,7,9 | cut -d ':' -f 2 | grep "200" | sort -u | cut -d ' ' -f 2 | sed "s#.*/##" | grep -v "?Cache" | grep "\.iso" >> temporary.txt
#sort temporary.txt | uniq -c | sort -rn > Small_Script_1.2.txt
#rm temporary.txt | open Small_Script_1.2.txt

# ORIGINAL 2 - WYŚWIETLA WSZYSTKO
#grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort -u | sed "s#.*/##" | grep "\.iso" > temporary.txt
#sort cdlinux.www.log | cut -d ' ' -f 1,7 | cut -d ':' -f 2 | sort -u | cut -d ' ' -f 2 | sed "s#.*/##" | grep "\.iso$" >> temporary.txt
#sort temporary.txt | uniq -c | sort -rn > Small_Script_1.3.txt
#rm temporary.txt | open Small_Script_1.3.txt

# FIRST VERSION !!!
#grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | sort -u | sed "s#.*/##" | grep "\.iso" > temporary.txt
#grep "cdlinux-" cdlinux.www.log | cut -d ' ' -f 1,7,9 | cut -d ':' -f 2 | grep "200" | sort -u | cut -d ' ' -f 2 | sed "s#.*/##" | grep -v "?Cache" | grep "\.iso" >> temporary.txt
#sort temporary.txt | uniq -c | sort -rn > Small_Script_1.4.txt
#rm temporary.txt | open Small_Script_1.4.txt
