#!/bin/bash
function snmp {
  for IP in $1;do
    CADRIGENAME=$(snmpwalk -t 1 -r 2 -c public -Os -v 2c $IP mib-2.43.11.1.1.6 2>/dev/null | sed -E -e 's/$/\\n /g' )
    PERCENTAGE=$(snmpwalk -t 1 -r 2 -c public -Os -v 2c $IP mib-2.43.11.1.1.9 2>/dev/null | sed -E -e 's/$/\\n /g' )
    PRINTER=$(snmpwalk -t 1 -c public -Ov -v 2c $IP sysName.0 | awk '{print $2 }' )
    DIS_BLACK=$(echo -e $CADRIGENAME | awk '/mib-2.43.11.1.1.6.1.1/  {print $4 " " $5 " " $6 " " $7 " " $8}' )
    DIS_CYAN=$(echo -e $CADRIGENAME | awk '/mib-2.43.11.1.1.6.1.2/  {print $4 " " $5 " " $6 " " $7 " " $8}' )
    DIS_MAGENTA=$(echo -e $CADRIGENAME | awk '/mib-2.43.11.1.1.6.1.3/  {print $4 " " $5 " " $6 " " $7 " " $8}' )
    DIS_YELLOW=$(echo -e $CADRIGENAME | awk '/mib-2.43.11.1.1.6.1.4/  {print $4 " " $5 " " $6 " " $7 " " $8}' )
    BLACK=$(echo -e $PERCENTAGE | awk '/mib-2.43.11.1.1.9.1.1/  {print $4}' )
    CYAN=$(echo -e $PERCENTAGE | awk '/mib-2.43.11.1.1.9.1.2/  {print $4}' )
    MAGENTA=$(echo -e $PERCENTAGE | awk '/mib-2.43.11.1.1.9.1.3/  {print $4}' )
    YELLOW=$(echo -e $PERCENTAGE | awk '/mib-2.43.11.1.1.9.1.4/  {print $4}')
    if [[ $BLACK -lt 20 && $BLACK -ne '' ]];then
        echo "$IP $PRINTER hat wenig $DIS_BLACK ! $BLACK%"
    fi
    if [[ $CYAN -lt 20 && $CYAN -ne '' ]];then
        echo "$IP $PRINTER hat wenig $DIS_CYAN ! $CYAN%"
    fi
    if [[ $MAGENTA -lt 20  && $MAGENTA -ne '' ]];then
        echo "$IP $PRINTER hat wenig $DIS_MAGENTA ! $MAGENTA%"
    fi
    if [[ $YELLOW -lt 20  && $YELLOW -ne '' ]];then
        echo "$IP $PRINTER hat wenig $DIS_YELLOW ! $YELLOW%"
    fi
  done
}

if [ $# -eq 0 ];then
  for LAST in {30..60};do
    IP="10.155.13.$LAST"
    snmp $IP
  done
else
  for IP in $@;do
    snmp $IP
  done
fi
