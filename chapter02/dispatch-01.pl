use 5.010;
use strict;
use warnings;

use Cwd 'getcwd';

our $VERBOSITY = 0;

sub read_config {
    my ($filename) = @_;

    open my ($file), $filename or return;
    while (<$file>) {
        chomp;    # trim newlines
        my ( $directive, $rest ) = split /\s+/, $_, 2;

        if ( $directive eq 'CHDIR' ) {
            chdir($rest) or die "Couldn't chdir to '$rest': $!; aborting";
        }
        elsif ( $directive eq 'LOGFILE' ) {
            open STDERR, ">>", $rest
              or die "Coudln't open log file '$rest': $!; aborting";
        }
        elsif ( $directive eq 'VERBOSITY' ) {
            $VERBOSITY = $rest;
        }
        else {
            die
              "Unknown directive $directive on line $. of $filename; aborting";
        }
    }
    return 1;
}

say("Reading configuration from settings-01.conf file");
read_config('./settings-01.conf');
say("VERBOSITY: $VERBOSITY");
say( "WORKING DIRECTORY: ", getcwd );
