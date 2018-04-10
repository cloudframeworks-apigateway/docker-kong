#!/bin/bash
set -e

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"

# Setting default prefix (override any existing variable)
export KONG_PREFIX="/usr/local/kong"

# Prepare Kong prefix
if [ "$1" = "/usr/local/openresty/nginx/sbin/nginx" ]; then
	kong prepare -p "/usr/local/kong"
fi
# Prepare database
for (( i = 0; i < 20; i++))
do 
   echo "step $i exec kong migrations up"
   kong migrations up
   if [ $? -eq 0 ];then
      break
   fi
   sleep 2
done

exec "$@"
