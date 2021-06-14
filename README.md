# mPATH
Agile portfolio management for large programs and projects including those geographically dispersed


# update centos

        yum clean all &&  yum update -y

        yum-config-manager --enable epel


# install ruby

        gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
        
        curl -sSL https://get.rvm.io | sudo bash -s stable

        usermod -a -G rvm `username'

        export PATH="$PATH:$HOME/.rvm/bin"

        log out then log back in

        rvm install ruby-2.6.6

        rvm install ruby-devel-2.6.6

        bash -l -c "rvm use 2.6.6 --default"

# Install Mysql
        yum install mariadb-server mariadb

        yum install mysql-devel

        systemctl start mariadb

        systemctl enable mariadb

        mysql_secure_installation

        mysql -u root -p

        create database mpath_dev CHARACTER SET utf8 COLLATE utf8_general_ci;
      
        GRANT ALL PRIVILEGES ON mpath_dev.* TO 'user'@'localhost';

        exit

# be sure git is installed
        yum install git

#create /var/www and from there 
        mkdir /var/www
        
        cd /var/www/

        git clone https://github.com/MicroHealthLLC/mPATH

        vi /var/www/mPATH/config/database.yml

--enter the password for mysql where it says password then save and exit

# go to the cloned directory 
        cd /var/www/mPATH

        gem install rails

        gem install bundler

        yum install nodejs

        yarn install

        bundle install
        
        bin/rails db:migrate
        
        rake db:seed

        rake assets:precompile

        chown -R nginx:nginx *

# generate your secrets for config/secrets.yml

        rake secret

put that output in config/secrets.yml


# install passenger phusion

        yum install -y pygpgme curl

        curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo

        yum install -y  passenger || sudo yum-config-manager --enable cr && sudo yum install -y  passenger

# install nginx
        passenger-install-nginx-module
choose one.  install it into the directory of your choice.  but for the conf below, chose /etc/nginx/

# edit nginx.conf

        nano /etc/nginx/conf/nginx.conf

Below "http {" section, add these

        passenger_root /usr/share/ruby/vendor_ruby/phusion_passenger/locations.ini;
        passenger_ruby /usr/local/rvm/gems/ruby-2.6.6/wrappers/ruby;
        passenger_instance_registry_dir /var/run/passenger-instreg;

Below "server {" section
add these

        passenger_enabled on;
        rails_env production;

# restart nginx
you will have to create an nginx service now

        nano /lib/systemd/system/nginx.service
        
---then this below----
        
        Description=The NGINX HTTP and reverse proxy server
        After=syslog.target network-online.target remote-fs.target nss-lookup.target
        Wants=network-online.target
        
        [Service]
        Type=forking
        PIDFile=/run/nginx.pid
        ExecStartPre=/etc/nginx/sbin/nginx -t
        ExecStart=/etc/nginx/sbin/nginx
        ExecReload=/etc/nginx/sbin/nginx -s reload
        ExecStop=/bin/kill -s QUIT $MAINPID
        PrivateTmp=true
        
        [Install]
        WantedBy=multi-user.target

----end---

        enable the service

        systemctl enable nginx

        then start the service 

        service nginx start

# Setup
go to https://your-url/admin

login with temp account admin@example.com with password password

Change, configure and customize your instance.  callback uri for socialmedia setup below.

https://YourliveSiteDomain/users/auth/google_oauth2/callback

https://YourliveSiteDomain/users/auth/office365/callback
