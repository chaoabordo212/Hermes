#!/bin/bash

# - Bash script for automating web page word collection and making a wordlist

targeturl=''
urllist=''
verbose='false'

DateAndTime() { DateAndTime=$( date '+%d-%m-%Y | %H:%M:%S' ); echo -e "$DateAndTime"; }

print_usage() {
  printf "Usage:"
}

function CewlCrawl {
	echo -e "-----------------------------------------------------------------------------------"
	DateAndTime
	dirname='RESULTS/'$( echo $targeturl | cut -d "/" -f3 )
	mkdir -p $dirname
	resultfile=$dirname'/'$( echo $targeturl | cut -d "/" -f3 )".txt"
	sudo cewl -w $resultfile -d 3 -o -m 8 --lowercase --convert-umlauts $ver_flag $targeturl;
	
	wordcount=$(< $resultfile wc -l)
	echo "Finished crawling: "$line
	echo "Found words: "$wordcount
	echo -e "-----------------------------------------------------------------------------------"
	echo ""
}


while getopts 't:f:v' flag; do
	case "${flag}" in

	# Single URL
	t) targeturl="${OPTARG}"
	CewlCrawl
	;;

	# URL list
    f) urllist="${OPTARG}"
	pageno=$(< $urllist wc -l)
	echo "Number of URL addresses on the list:" $pageno
	input=$urllist
	while IFS= read -r line
	do
		targeturl=$line
		CewlCrawl

	done < "$input"
	echo "All URL on the list finished"
	;;

	# Verbose output
    v) verbose="true"
	ver_flag="-v"
    ;;
    *) print_usage
       exit 1 ;;

  	esac
done




