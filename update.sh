#!/bin/bash
LOGFILE=/var/log/mgisupdate.log

timestamp()
{
 date +"%Y-%m-%d %T"
}

exec &> >(tee $LOGFILE) 2>&1

set -x

echo "$(timestamp): Deploying mGis"

cd /var/www/mPATH \

&& sudo git pull \

&& bundle install \

&& rake db:migrate RAILS_ENV=production \

&& rake assets:precompile RAILS_ENV=production \

&& sudo chown -R puma:puma * \

&& sudo service puma restart

echo "$(timestamp): mPATH Deployed"

set +x
