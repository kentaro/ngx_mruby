#!/bin/sh

/usr/local/nginx/sbin/nginx &
/usr/bin/memcached -p 11211 -u memcache &
/usr/bin/memcached -p 11212 -u memcache &

/usr/bin/tail -f /dev/null
