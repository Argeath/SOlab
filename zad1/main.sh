#!/bin/bash

grep -oP "OK DOWNLOAD.*\.iso" cdlinux.ftp.log | cut -d '"' -f 2,4 | sed 's/".*\/v[0-9]\.[0-9]\/cd/ cd/' > tmp.log
grep -oP ':.*\.iso HTTP\/[0-9]\.[0-9]" 200' cdlinux.www.log | sed 's/ -.*\/cd/ cd/' | cut -c 2- | sed 's/HTTP.*//' >> tmp.log
sort -u tmp.log | cut -d " " -f 2 | grep -oP '[a-zA-Z0-9\-.]*\.iso' | sort | uniq -c > out.log
sort -u tmp.log | cut -d " " -f 2 | grep -oP '[a-zA-Z0-9\-.]*\.iso' | wc -l
rm tmp.log