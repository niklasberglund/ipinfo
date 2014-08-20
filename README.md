ipinfo.sh
======
A Bash shell-script wrapping the IP address information API of http://ipinfo.io. For request limits and more info about their service see http://ipinfo.io/developers. At the time of writing this the limitation is 1000 requests per day.

Usage
------
```
$ ./ipinfo.sh -h
Usage: ./ipinfo.sh [-f field] [IP address]
 -f field	Only output specified field's info. Run script without -f to see available fields.
 -h		    Show this help text.
```

Examples
------
### Current IP address info
```
$ ./ipinfo.sh
ip: 125.71.208.203
hostname: No Hostname
city: Chengdu
region: Sichuan
country: CN
loc: 30.6667,104.0667
org: AS4134 Chinanet
```

### Specified IP address info
```
$ ./ipinfo.sh 173.194.127.233
ip: 173.194.127.233
hostname: hkg03s16-in-f9.1e100.net
city: Mountain View
region: California
country: US
loc: 37.4192,-122.0574
org: AS15169 Google Inc.
postal: 94043
```

### Specify field (specified IP address)
```
$ ./ipinfo.sh -f city 173.194.127.233
Mountain View
```

### Specify field (current IP address)
```
$ ./ipinfo.sh -f ip
117.175.141.105
```
