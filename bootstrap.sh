#!/usr/bin/env bash

# Ensure apt-add-repository is available
if [[ ! -x `which apt-add-repository` ]] ; then
    echo "Installing apt-add-repository..."
    sudo apt-get install python-software-properties -y
fi

# add repos
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb

# It's not ideal, but this just needs to happen first
apt-get update

echo "#### INSTALLING Essentials ###"
apt-get install -y build-essential
apt-get install -y curl
apt-get install -y git
apt-get install -y unzip
apt-get install -y linux-tools-common
apt-get install -y emacs24-nox

#install development tools
echo "#### INSTALLING Development tools ###"
apt-get install -y openjdk-7-jdk
apt-get install -y elixir

#install servers
echo "#### INSTALLING POSTGRESQL ###"
apt-get install -y postgresql postgresql-contrib

# Install Leiningen
wget https://raw.github.com/technomancy/leiningen/stable/bin/lein -O /usr/local/bin/lein
chmod a+x /usr/local/bin/lein

#Install Meteor
apt-get install -y nodejs
apt-get install -y npm
npm install -g bower
curl https://install.meteor.com/ | sh

echo 'LC_ALL="en_US.UTF-8"'  >  /etc/default/locale
