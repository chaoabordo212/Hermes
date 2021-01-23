#!/bin/bash

# - Bash script for automating web page word collection and making a wordlist


verbose='false'
minwordlength='5'
depth=3
offsite='false'
includemail='false'
excludelist='false'
includelist='false'
lowercase='false'
convumlaut='false'

targeturl=''
urllist=''
offsite_flag=''
exclude_flag=''
include_flag=''
lowercase_flag=''
convumlaut_flag=''
mail_flag=''

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
	sudo cewl -d $depth -m $minwordlength $offsite_flag $exclude_flag $include_flag -w $resultfile $lowercase_flag $convumlaut_flag $mail_flag $verbose_flag $targeturl;
	
	wordcount=$(< $resultfile wc -l)
	echo "Finished crawling: "$line
	echo "Found words: "$wordcount
	echo -e "-----------------------------------------------------------------------------------"
	echo ""
}

count=0
while getopts 'm:d:o:E:I:l:c:e:t:f:v' flag; do
	case "${flag}" in

    # Min word length
    m) minwordlength="${OPTARG}"
	echo "minwordlength_debug: " $minwordlength ###DEBUG
	;;

	# Depth of search
	d) depth="${OPTARG}"
	echo "depth_debug: " $depth ###DEBUG
	;;

	# Search offsite
	o) offsite="true"
	offsite_flag="-o"
	;;

	# Exclude list location
	E) excludelist="${OPTARG}"
	exclude_flag="--exclude $excludelist"
	;;

	# Include list location
	I) includelist="${OPTARG}"
	include_flag="--include $includelist"
	;;

	# Convert all to lowercase
	l) lowercase="true"
	lowercase_flag="--lowercase"
	;;

	# Sanitize umlaut
	c) convumlaut="true"
	convumlaut_flag="--convert-umlauts"
	;;

	# Include e-mail addresses
	e) includemail="true"
	mail_flag="-e"
	;;	

	# Single URL
	t) targeturl="${OPTARG}"
	echo "Crawling URL: " $targeturl
	CewlCrawl
	;;

	# URL list
    f) urllist="${OPTARG}"
	pageno=$(< $urllist wc -l)
	echo "Number of URL addresses on the list:" $pageno
	input=$urllist
	while IFS= read -r line
	do
		((count=count+1))
		targeturl=$line
		CewlCrawl
		echo "Finished URL:"
		echo "$Line"
		if [ "$count" == "$pageno" ]; then
			echo "All URL on the list finished"
			exit 1
		fi
		echo "Continuing to the next line"
	done < "$input"
	;;
	
	# Verbose output
    v) verbose="true"
	verbose_flag="-v"
    ;;

	*) print_usage
       exit 1 ;;
  	esac
done

