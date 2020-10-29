#!/bin/bash
echo "Deploying mGis"

cd /var/www/mGis \
&& sudo git pull \
&& sudo bundle install \
&& sudo rake db:migrate \ 
&& sudo yarn install \
&& sudo rake assets:precompile \ 
&& sudo chown -R nginx:nginx * \
&& sudo systemctl restart nginx \
&& sudo echo "mGis deployed successfully"
