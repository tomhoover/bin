#!/bin/bash

# Exit immediately on error.
set -e

PATH=$PATH:/usr/local/bin
FILE="$HOME/Dropbox/lastip"
LASTIP=`cat $FILE`
WAN=`dig +short myip.opendns.com @resolver1.opendns.com`

if [[ `hostname -s` == "unraid" ]]; then
  [[ -f /root/.boto ]] && . /root/.boto
  CLI53="docker run --rm -e AWS_ACCESS_KEY_ID=${aws_access_key_id} -e AWS_SECRET_ACCESS_KEY=${aws_secret_access_key} tomhoover/docker-cli53"
else
  [ `which cli53` ] || brew install cli53
  CLI53="cli53"
fi

if [[ "$LASTIP" != "$WAN" ]]; then
	echo "IP changed from $LASTIP to $WAN"
	echo $WAN > $FILE
#	${CLI53} rrcreate --replace --ttl 300 t0m.us @ A $WAN	# previous command (for python cli53)
#	${CLI53} rrcreate --replace t0m.us '@ 300 A' ${WAN}	# won't work--space must be inside single quote to work
if [[ "$HOSTNAME" == "unraid" ]]; then
        ${CLI53} rrcreate --replace t0m.us '@ 300 A '${WAN}
    else
        ${CLI53} rrcreate --replace t0m.us ${HOSTNAME}' 300 A '${WAN}
    fi
fi

# https://github.com/barnybug/cli53

