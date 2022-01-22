#!/usr/bin/env bash
INFO=`tput setaf 6`
RESET=`tput sgr0`

echo "${red}red text ${green}green text${reset}"
PERL=perl-5.32.1
PROJECT="$PERL@hop"

source $HOME/perl5/perlbrew/etc/bashrc
perlbrew use $PERL

env=`perlbrew list | grep "$PROJECT" | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g' `
if [ "$env" == "$PROJECT" ]; then
    echo "Environment already created!"
else
    perlbrew lib create "$PROJECT" \
        && perlbrew use "$PROJECT" \
        && cpanm --installdeps . \
        && touch .setup
fi
echo "${INFO}Run 'source ./toggle-shell.sh' to activate environment"
