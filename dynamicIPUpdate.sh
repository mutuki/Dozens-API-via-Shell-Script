#!/bin/bash

# KEYWORDS
USERNAME="mutuki"
XAUTHKEY="40a3b1d793bff21541c9c24fc36454bcbb832672"
SERVERNAME="wiki.kuropug.com"
echo "Dozens dynamic IP setter version 0.3b"

# Get Global IP address
GLOBALIP=$(curl -s ifconfig.me)
echo "Your global IP is $GLOBALIP"$'\n'

# auth initialization
echo "auth initialization start."
MYKEY=$(curl -s http://dozens.jp/api/authorize.json -H X-Auth-User:$USERNAME -H X-Auth-Key:$XAUTHKEY |sed 's/[{"}:]//g' | sed 's/auth_token//')
echo "Your key is : $MYKEY"$'\n'

# Get wikiserver id
echo "Serching $SERVERNAME record..."
LINENUMBER=$(echo $(expr $(curl -s http://dozens.jp/api/record/kuropug.com.json -H X-Auth-Token:$MYKEY | tr "," "\n" | grep -n $SERVERNAME | sed 's/[a-z":.]//g') - 1)"p")
RECORDID=$(curl -s http://dozens.jp/api/record/kuropug.com.json -H X-Auth-Token:$MYKEY | tr "," "\n" | sed -n $LINENUMBER | sed -e 's/[a-z"{}:.]//g')
echo "$SERVERNAME record id is $RECORDID""."$'\n'

# Set IP Address
echo "Recode update in progress..."
RESULT=$(curl -s -d "{\"prio\":\"\", \"content\":\"$GLOBALIP\", \"ttl\":\"7200\"}" http://dozens.jp/api/record/update/$RECORDID.json -H X-Auth-Token:$MYKEY -H "Host: dozens.jp" -H "Content-Type:application/json" | sed -e 's/\[/\[ /g' -e 's/\]/ \]/g' -e 's/},{/} {/g' | tr " " "\n" | grep $RECORDID)
echo "Dozens server says : $RESULT"$'\n'
echo "Script is done!"$'\n'