#!/bin/bash
#
# Credit to http://ipinfo.io for providing the IP address info service. This script is a wrapper around their service, for convenience.
#
# Created by Niklas Berglund <niklas.berglund@gmail.com>
# https://github.com/niklasberglund/ipinfo

url="ipinfo.io"

usage() {
	echo "Usage: $0 [-f field] [IP address]" 1>&2
	echo " -f field	Only output specified field's info. Run script without -f to see available fields." 1>&2
	echo " -w		Force use wget instead of curl" 1>&2
	echo " -h		Show this help text." 1>&2
}

while getopts "f:hw" o; do
    case "${o}" in
        w)
                use_wget=1
                ;;

        f)
            f=${OPTARG}
            ;;
		h)
			usage
			exit 0
			;;
        *)
            usage
			exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# Simple IPv4/IPv6 check. Creds to http://stackoverflow.com/a/20423004/257577
function is_valid_ip_address {
	echo $(echo "$*" | grep -Ec '^(([0-9a-f]{0,4}:){1,7}[0-9a-f]{1,4}|([0-9]{1,3}\.){3}[0-9]{1,3})$')
}

# Specified IP address
if [ ! -z "$*" ]; then
	if [ $(is_valid_ip_address $*) -eq 0 ]; then
		echo "Error: The IP address must be in IPv4 or IPv6 format" 1>&2
		exit 1
	fi

	url="$url/$*"
fi

# Specified field
if [ ! -z "$f" ]; then
	url="$url/$f"
else
	# Make sure we get json obj and not the webpage
	url="$url/json"
fi

# Check if curl exists, if not try wget.
if ! hash curl 2> /dev/null || [ -n "$use_wget" ]; then
	the_info=$(wget -O- -q $url)
else
	the_info=$(curl -s $url)
fi

if [[ $the_info == *"502 Bad Gateway"* || $the_info == "undefined" ]]; then
	echo "Error: Invalid endpoint. Perhaps you specified a non-existing field?"
	usage
	exit 1
fi

echo "$the_info" | sed -e '/[{}]/d' | sed 's/\"//g' | sed 's/  //g' | sed 's/,$//'
