#!/usr/bin/env bash

PERL=perl-5.32.1
PROJECT="$PERL@hop"

source $HOME/perl5/perlbrew/etc/bashrc
perlbrew use $PERL

perlbrew lib delete "$PROJECT"
rm -f .setup
perlbrew list
