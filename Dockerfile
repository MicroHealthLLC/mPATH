# Use AlmaLinux base image
FROM almalinux:9

# Environment variables for non-interactive installation
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install EPEL repository and necessary packages with all dependencies
RUN yum install -y epel-release yum-utils && \
    yum-config-manager --enable epel && \
    yum clean all && \
    yum update -y && \
    yum install -y --allowerasing curl git wget sudo which gcc-c++ patch readline readline-devel zlib zlib-devel \
    libffi-devel openssl-devel make bzip2 autoconf automake libtool bison \
    sqlite-devel python3 python3-pip nodejs mariadb-server

# If libyaml and iconv devel packages are needed and not found, consider installing 'glibc-devel' and finding an alternative way to install libyaml
RUN echo "UPDATE mysql.user SET Password=PASSWORD('your_password') WHERE User='root';" | mysql --user=root
RUN echo "DELETE FROM mysql.user WHERE User='';" | mysql --user=root
RUN echo "DELETE FROM mysql.db WHERE Db='test' or Db='test\\_%';" | mysql --user=root
RUN echo "FLUSH PRIVILEGES;" | mysql --user=root

# Install RVM
RUN curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg2 --import - && \
    curl -sSL https://get.rvm.io | sudo bash -s stable && \
    source /etc/profile.d/rvm.sh && \
    rvm reload && \
    rvm requirements run && \
    rvm install 2.6.6 && \
    rvm use 2.6.6 --default && \
    gem install bundler rails

# Install Passenger & Nginx
RUN curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo && \
    yum install -y nginx passenger passenger-devel && \
    /usr/bin/passenger-install-nginx-module --auto --languages ruby --prefix=/etc/nginx

# Copy custom nginx config and service file
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./nginx.service /lib/systemd/system/nginx.service

# Set up MariaDB
RUN systemctl enable mariadb && \
    systemctl start mariadb && \
    mysql_secure_installation

# Clone mPATH
RUN mkdir -p /var/www && \
    cd /var/www && \
    git clone https://github.com/MicroHealthLLC/mPATH && \
    cd mPATH && \
    bundle install && \
    yarn install && \
    rails db:create RAILS_ENV=production && \
    rails db:migrate RAILS_ENV=production && \
    rails db:seed RAILS_ENV=production && \
    rake assets:precompile RAILS_ENV=production

# Set ownership
RUN chown -R nginx:nginx /var/www/mPATH

# Expose Nginx port
EXPOSE 80

# Set up the CMD
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]