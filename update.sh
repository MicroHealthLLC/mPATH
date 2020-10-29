#!/bin/bash
LOGFILE=/var/log/mgisupdate.log

timestamp()
{
 date +"%Y-%m-%d %T"
}

exec &> >(tee $timestamp $LOGFILE) 2>&1

set -x

echo "$(timestamp): Deploying mGis"

cd /var/www/mGis \
&& sudo git pull \
&& bundle install \
&& rake db:migrate \
&& yarn install \
&& rake assets:precompile \
&& sudo chown -R nginx:nginx * \
&& sudo nginx -s reload \

echo "$(timestamp): mGis Deployed"

set +x
