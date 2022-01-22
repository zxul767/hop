#!/usr/bin/env bash
INFO=`tput setaf 6`
RESET=`tput sgr0`

PERL=perl-5.32.1
PROJECT="$PERL@hop"

env=`perlbrew list | grep "$PROJECT" | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g'`
if [ "$env" = "$PROJECT" ]; then
    source $HOME/perl5/perlbrew/etc/bashrc
    perlbrew use $PROJECT
    echo "${INFO}Environment is now ON"
    perlbrew list
else
    perlbrew use $PERL
    echo "${INFO}Environment is now OFF"
    perlbrew list
fi
