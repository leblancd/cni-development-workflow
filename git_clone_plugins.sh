#!/bin/bash

################################################################
# Shell script for cloning a personal fork of the
# https://github.com/containernetworking/plugins repo.
# Assumes that you've already gone to the containernetworking
# plugins repo and clicked on the <Fork> button to create
# your own personal fork.
################################################################

function usage {
    echo "usage: $0 [-h | --help ] [-u github-username | --username github-username]"
    exit 1
}

function no_gopath {
    echo "\$GOPATH is not defined. Is Go installed?"
    exit 1
}

# Check GOPATH env
if [[ ! $GOPATH ]]; then no_gopath; fi

# Process command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    HELP=true
    ;;
    -u|--username)
    USERNAME="$2"
    shift # past argument
    ;;
esac
shift # past argument or value
done

# Display usage information if requested
if [[ $HELP ]]; then usage; fi

# Display usage if username is not supplied
if [[ ! $USERNAME ]]; then usage; fi

working_dir=$GOPATH/src/github.com/containernetworking
user=$USERNAME
repo=plugins
upstream_repo=containernetworking/$repo

mkdir -p $working_dir
cd $working_dir
git clone https://github.com/$user/$repo.git

# Add upstream repo
cd $working_dir/$repo
git remote add upstream https://github.com/$upstream_repo.git

# Never push to upstream master
git remote set-url --push upstream no_push

# Confirm that remote makes sense
git remote -v

cd $working_dir/$repo
go get ./...
