#!/bin/bash

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"

# Setting default prefix (override any existing variable)
export KONG_PREFIX="/usr/local/kong"

# Prepare Kong prefix
if [ "$1" = "/usr/local/openresty/nginx/sbin/nginx" ]; then
	kong prepare -p "/usr/local/kong" || { echo "kong prepare failed"; exit 1; }
fi
# Prepare database
for (( i = 0; i < 20; i++))
do
   kong migrations up
   if [ $? -eq 0 ];then
      break
   fi
   echo "step $i exec kong migrations up failure, retry..."
   if [ $i -eq 19 ];then
      echo "waiting postgres db ready timeout. exist"
      exit 1
   fi
   sleep 2
done

exec "$@"
