#!/bin/bash
#ban ip except http trafic on port 80

IP=$1

#verifica numar parametri
if [ $# -ne 1 ] 
        then
                echo "trebuie trecut un singur IP ca parametru"
                echo "parametri script WRONG" >&2
                exit 1
fi

#verifica daca parametrul dat este un IP
if [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]  
        then
                echo "Ip-ul pare ok"
        else
                echo "IP-ul pare cam dubios" >&2
                exit 1
fi

#folosind input va adauga default pozitia numarul 1 pentru regula => ordinea comenzilor inversata pentru ca accept sa fie mai sus ca drop.

#drop all from IP
iptables -I INPUT -i eth0 -s $IP -j DROP
#accept http from IP
iptables -I INPUT -p tcp -i eth0 -s $IP --destination-port 80 -j ACCEPT
