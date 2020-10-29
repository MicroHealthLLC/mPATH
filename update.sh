#!/bin/bash
LOGFILE=/var/log/mgisupdate.log
exec &> >(tee $LOGFILE)
set -x

echo "Deploying mGis"

cd /var/www/mGis \
&& sudo git pull \
&& bundle install \
&& rake db:migrate \
&& yarn install \
&& rake assets:precompile \
&& sudo chown -R nginx:nginx * \
&& sudo nginx -s reload \
&& echo "mGis deployed successfully"
set +x
