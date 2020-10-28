cd /var/www/mGis
git pull
bundle install
rake db:migrate 
yarn install
rake assets:precompile
chown -R nginx:nginx *
systemctl restart nginx
