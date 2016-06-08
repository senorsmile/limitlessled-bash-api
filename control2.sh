#!/usr/bin/env bash

#-------------------------------
# user editable settings
#-------------------------------
ipaddress="192.168.88.192"
portnum="50000"
#-------------------------------



if [ -z "$2" ] ; then
	echo "You must enter at leas ttwo parameters: " 
	echo "  e.g. $0 all on"
  echo "       $0 zone1 up 2"
	echo
	echo "Available options:"
	echo "all, zone1, zone2, zone3, zone4"
	echo "on, off, up, down, night, full"
	exit 1
fi


ver="2.0"

zone="$1"
cmd="$2"
cx="$3"

#echo "Zone=${zone}"
#echo "Cmd=${cmd}"


sendudp() {
  local incmd="$1"
  echo -n -e "$incmd" >/dev/udp/"$ipaddress"/"$portnum"
}


allon="\x35\00\x55"
alloff="\x39\00\x55"
zone1on="\x38\00\x55"
zone1off="\x3B\00\x55"
zone2on="\x3D\00\x55"
zone2off="\x33\00\x55"
zone3on="\x37\00\x55"
zone3off="\x3A\00\x55"
zone4on="\x32\00\x55"
zone4off="\x36\00\x55"

allnight="\x39\00\x55"
allnight2="\xB9\00\x55"
zone1night="\x3B\00\x55"
zone1night2="\xBB\00\x55"
zone2night="\x33\00\x55"
zone2night2="\xB3\00\x55"
zone3night="\x3A\00\x55"
zone3night2="\xBA\00\x55"
zone4night="\x36\00\x55"
zone4night2="\xB6\00\x55"

allfull="\x35\00\x55"
allfull2="\xB5\00\x55"
zone1full="\x35\00\x55"
zone1full2="\xB5\00\x55"
zone2full="\x35\00\x55"
zone2full2="\xB5\00\x55"
zone3full="\x35\00\x55"
zone3full2="\xB5\00\x55"
zone4full="\x35\00\x55"
zone4full2="\xB5\00\x55"

up="\x3c\00\x55"
down="\x34\00\x55"


case $cmd in
  on|off)
    outcmd="$zone""$cmd"
    eval outcmd=\$$outcmd
    sendudp $outcmd
    ;;

  up|down)
    outcmd="$zone""on"
    eval outcmd=\$$outcmd
    sendudp $outcmd

    sleep 1

    if ! [[ -v $cx ]] && ! [[ $cx =~ ^-?[0-9]+$ ]]; then
      cx=1
    fi

    for ((i=1;i<=$cx;i++)); do
      eval outcmd=\$$cmd
      sendudp $outcmd
      echo $i
      sleep 2
    done
    ;;

  night|full)
    outcmd="$zone""$cmd"
    eval outcmd=\$$outcmd
    sendudp $outcmd

    sleep 1

    outcmd="$zone""$cmd""2"
    eval outcmd=\$$outcmd
    sendudp $outcmd
    ;;

esac

