# Image subject to change
FROM ubuntu:20.04

# Environment Vars
ENV NODE_VERSION 14.18.2
ENV NVM_DIR /root/.nvm
ENV YARN_VERSION 1.22.17
ENV DEBIAN_FRONTEND=noninteractive


# Install dependencies and update the system
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y gnupg curl git mysql-client libmysqlclient-dev && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt install yarn -y

# Install Node.js using NVM
RUN . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default && \
    npm install -g yarn@$YARN_VERSION && \
    npm cache clear --force && \
    yarn cache clean --force

# Install RVM and Ruby
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN /bin/bash -l -c "rvm install 3.1.0 && rvm use 3.1.0 --default"
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc

# Set the working directory in the container
WORKDIR /app

COPY . .

RUN /bin/bash -l -c "gem install bundler"
RUN /bin/bash -l -c "bundle install"
RUN /bin/bash -l -c "rails -v"

# Create and migrate the database
# RUN /bin/bash -l -c "rake db:create" 
# RUN /bin/bash -l -c "rake db:migrate" 
# RUN /bin/bash -l -c "rake db:seed"
EXPOSE 3000

CMD /bin/bash -l -c "rails s -b 0.0.0.0"

