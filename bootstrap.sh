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

## Idempotently check for presence of and install a package
check_and_install () {
    if [[ ! -x `which $1` ]] ; then
        echo "Installing $1..."
        apt-get install $1 -y
    else
        echo "$1 already installed, skipping."
    fi
}

check_and_install build-essential
check_and_install curl
check_and_install git
check_and_install unzip
check_and_install tmux
check_and_install tree
check_and_install vim
check_and_install elixir

# Install the editor
apt-get build-dep emacs24
wget http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
tar -xf emacs-24.5.tar.gz && cd emacs-24.5
./configure && make && make install

#install jdk 
apt-get install -y openjdk-7-jdk

# Install Leiningen
wget https://raw.github.com/technomancy/leiningen/stable/bin/lein -O /usr/local/bin/lein
chmod a+x /usr/local/bin/lein

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

