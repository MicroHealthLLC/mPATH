#!/bin/bash
LOGFILE=/var/log/mgisupdate.log

timestamp()
{
 date +"%Y-%m-%d %T"
}

exec &> >(tee $LOGFILE) 2>&1

set -x

echo "$(timestamp): Deploying mGis"

cd /var/www/mGis \
&& sudo git pull \
&& cd /var/www/mGis \
&& bundle install \
&& cd /var/www/mGis \
&& rake db:migrate \
&& cd /var/www/mGis \
&& yarn install \
&& cd /var/www/mGis \
&& rake assets:precompile \
&& cd /var/www/mGis \
&& sudo chown -R nginx:nginx * \
&& sudo nginx -s reload \

echo "$(timestamp): mGis Deployed"

set +x
