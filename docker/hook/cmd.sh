#!/bin/sh

/usr/local/nginx/sbin/nginx
/usr/bin/redis-server --port 6379 &
/usr/bin/redis-server --port 6380 &
