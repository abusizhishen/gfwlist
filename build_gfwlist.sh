#!/bin/sh

cat list.txt list.my.txt | sort | uniq > merged_gfwlist.txt

base64 merged_gfwlist.txt > gfwlist.new.txt