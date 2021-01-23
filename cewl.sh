#!/bin/bash

# - Bash script for automating web page word collection and making a wordlist
# # Arguments: 
# -m <min_word_length>        ---
# -d <crawling_depth>
# -o 	Follow links out of domain
# -E <exclude_list_path>
# -I <must_include_list_path>
# -l    Convert words to lowercase
# -c    Sanitize umlaut characters
# -e    Grab e-mail addresses
# -t <target_url>
# -f <list_of_urls>
# -v    Show verbose output

verbose='false'
minwordlength='5'
depth=3
offsite='false'
# includemail='false'
# excludelist='false'
# includelist='false'
# lowercase='false'
# convumlaut='false'
# lowercase=''
# convumlaut=''
# targeturl=''
# urllist=''
# offsite_flag='false'
# exclude_flag=''
# include_flag=''
# lowercase_flag=''
# convumlaut_flag=''
# mail_flag=''

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
	# if not offsite
	#sudo cewl -d $depth -m $minwordlength $offsite_flag $exclude_flag $include_flag -w $resultfile $lowercase_flag $convumlaut_flag $mail_flag $verbose_flag $targeturl;
	# sudo cewl "$cewl_query_args" -w $resultfile $targeturl
	sudo cewl -d $depth -m $minwordlength -o -w $resultfile --lowercase --convert-umlauts -v $targeturl;
	
	wordcount=$(< $resultfile wc -l)
	echo "Finished crawling: "$line
	echo "Found words: "$wordcount
	echo -e "-----------------------------------------------------------------------------------"
	echo ""
}

count=0
while getopts 'd:m:t:f' flag; do
	case "${flag}" in

	# Depth of search
	d) depth="${OPTARG}"
	;;

    # Min word length
    m) minwordlength="${OPTARG}"
	;;

	# # Search offsite
	# o) offsite="true"
	# #offsite_flag="-o"
	# ;;

	# # Exclude list location
	# E) excludelist="${OPTARG}"
	# exclude_flag="--exclude $excludelist"
	# cewl_query_args="$cewl_query_args $exclude_flag"
	# ;;

	# # Include list location
	# I) includelist="${OPTARG}"
	# include_flag="--include $includelist"
	# cewl_query_args="$cewl_query_args $include_flag"
	# ;;

	# # Convert all to lowercase
	# l) lowercase="true"
	# lowercase_flag="--lowercase"
	# cewl_query_args="$cewl_query_args $lowercase_flag"
	# ;;

	# # Sanitize umlaut
	# c) convumlaut="true"
	# convumlaut_flag="--convert-umlauts"
	# cewl_query_args="$cewl_query_args $convumlaut_flag"
	# ;;

	# # Include e-mail addresses
	# e) includemail="true"
	# mail_flag="-e"
	# cewl_query_args="$cewl_query_args $mail_flag"
	# ;;	

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
	
	# # Verbose output
 #    v) verbose="true"
	# verbose_flag="-v"
	# echo "Verbose true"
 #    ;;

	*) print_usage
       exit 1 ;;
  	esac
done

