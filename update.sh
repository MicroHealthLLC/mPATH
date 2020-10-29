#!/bin/bash
LOGFILE=/var/log/mgisupdate.log

adddate() {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date)" "$line";
    done
}

exec &> >(tee date -u $LOGFILE) 2>&1

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
