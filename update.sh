cd /var/www/mGis
git pull
bundle install
rake db:migrate RAILS_ENV=production
yarn install
rake assets:precompile RAILS_ENV=production
chown -R nginx:nginx *
systemctl restart nginx
