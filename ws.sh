#!/bin/bash

#check args script
if [ $# -ne 2 ]
	then
		echo "an option must be used (a for all tests, s only OSINT) and only one domain"
		echo "the script does not have 2 arguments" >&2
		exit 1
fi

#variabile
optiune=$1
domeniu=$2

#check that there are no subdomains. there are 63 characters max, etc
if [[ $domeniu =~ ^([a-zA-Z0-9-]{2,63})[.]([a-zA-Z]{2,63})$  ]]
	then
		echo "the domain looks OK"
	else
		echo "the domain does not look to be valid" >&2
		exit 1
fi


#functii
osint(){
	# deschide pagina (doh!)
	firefox --new-tab "$domeniu" &
	sleep 2
	
	# pagini pt OSINT
	firefox --new-tab toolbar.netcraft.com/site_report?url=http://"$domeniu" & 
	sleep 2
	#poate tab pt arin.net pt block IP
	#firefox --new-tab http://whois.arin.net/rest/net/NET-216-239-32-0-1/pft
	#sleep 2
	firefox --new-tab myipneighbors.net/?s="$domeniu" &
	sleep 2
	#sitedosier vede ce site-uri mai sunt hostate pe IP
	firefox --new-tab http://www.sitedossier.com/site/"$domeniu" &
	sleep 2

	#domain DNS history
	firefox --new-tab who.is/domain-history/"$domeniu" & 
	sleep 2
	
	#google
	firefox --new-tab google.com/?q=site%3A"$domeniu" &
	sleep 2
	firefox --new-tab google.com/?q=filetype%3Axls+OR+filetype%3Axlsx+site%3A"$domeniu" &
	sleep 2
	firefox --new-tab google.com/?q=filetype%3Appt+OR+filetype%3Apptx+site%3A"$domeniu" &
	sleep 2
	firefox --new-tab google.com/?q=filetype%3Adoc+OR+filetype%3Adocx+site%3A"$domeniu" &
	sleep 2
	firefox --new-tab google.com/?q=filetype%3Apdf+site%3A"$domeniu" &
	sleep 2
	firefox --new-tab google.com/?q=filetype%3Atxt+site%3A"$domeniu" &
	sleep 2
	#google safeserch
	firefox --new-tab http://google.com/safebrowsing/diagnostic?site="$domeniu" &

	#bing
	firefox --new-tab https://www.bing.com/search?q=ip%3A$(dig a +short "$domeniu" | head -1)

	#urlvoid
	firefox --new-tab http://www.urlvoid.com/scan/"$domeniu" &
	sleep 2

	# robtex
	# firefox --new-tab https://www.robtex.com/q/x1?q="$domeniu" &
	
	# ruleaza whois si printeaza intr-o pagina web
	echo "<pre>$(whois "$domeniu")</pre>" > /tmp/whois."$domeniu" && firefox --new-tab /tmp/whois."$domeniu"
	
	#whois.domaintools.com
	#firefox --new-tab http://whois.domaintools.com/"$domeniu"
	
	#tracepath ??? descopera MTU pana la destinatie
	# echo "<pre> tracepath "$domeniu"  </pre>" > /tmp/tracepath."$domeniu" && firefox --new-tab /tmp/tracepath."$domeniu"

	#traceroute -hopuri pana la tinta pt IPV4... ar trebui si pt IPV6
	# echo "<pre> traceroute "$domeniu"  </pre>" > /tmp/traceroute."$domeniu" && firefox --new-tab /tmp/traceroute."$domeniu"

	# dig any
	echo "<pre>$(dig +noall +answer any "$domeniu")</pre>" > /tmp/dig."$domeniu" && firefox --new-tab /tmp/dig."$domeniu"
}

scans(){
	# namp and stuff
	echo "<pre>$(nmap -T4 -A -p 1-65535 "$domeniu")</pre>" > /tmp/nmap."$domeniu" && firefox --new-tab /tmp/nmap."$domeniu"

	# fierce and stuff
	# /path/to/fierce.pl "$domeniu" -wordlist /path/to/hosts.txt

	# dirb and stuff
	# /path/to/dirb222/dirb "$domeniu" /path/to/dirb222/wordlists/big.txt

	# dnsrecon poate
	# /path/to/dnsrecon/dnsrecon.py -d "$domeniu" -w
}

usage(){ 
	echo "Usage: $0 [a(all)|s(stealth?)] [domeniul]" 1>&2; 
	exit 1; 
}


#verifica optiunea specificata si make the thing do the thing
if [ "$optiune" == a ]
	then
	"osint"
	"scans"
	elif [ "$optiune" == s ]
		then
			"osint"
	elif [ "$optiune" != a,s ]
		then
			echo "a(all) sau s(stealth) + domeniu"
			exit 1;
fi
