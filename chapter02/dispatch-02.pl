use 5.010;
use strict;
use warnings;

use Cwd 'getcwd';

our $VERBOSITY = 0;
our $DEBUG = 0;

our $GLOBAL_ACTIONS = {
    'CHDIR' => \&change_dir,
    'LOGFILE' => \&open_log_file,
    'VERBOSITY' => \&set_verbosity,
    'DEBUG' => \&set_debug,
    'DEFINE' => \&define_config_directive,
};

sub read_config {
    my ($filename, $actions) = @_;

    open my ($file), $filename or return;
    while (<$file>) {
        chomp; # trim newlines
        my ($directive, $rest) = split /\s+/, $_, 2;
        if (exists $actions->{$directive}) {
            $actions->{$directive}->($rest, $actions);
        } else {
            die "Unrecognized directive $directive on line $. of $filename; aborting";
        }
    }
    return 1;
}

sub change_dir {
    my ($dir) = @_;
    chdir($dir)
        or die "Couldn't chdir to '$dir': $!; aborting";
}

sub open_log_file {
    open STDERR, ">>", $_[0]
        or die "Couldn't open log file '$_[0]': $!; aborting";
}

sub set_verbosity {
    $VERBOSITY = shift;
}

sub set_debug {
    $DEBUG = shift;
}

sub define_config_directive {
    my ($rest, $dispatch_table) = @_;

    $rest =~ s/^\s+//; # trim leading whitespace
    my ($new_directive, $definition_string) = split /\s+/, $rest, 2;

    if (exists $dispatch_table->{$new_directive}) {
        warn "$new_directive already defined; skipping.\n";
        return;
    }
    my $definition = eval "sub { $definition_string }";
    if (not defined $definition) {
        warn "Couldn't compile definition for '$new_directive': $@; skipping.\n";
        return;
    }
    $dispatch_table->{$new_directive} = $definition;
}

say("Reading configuration from settings-02.conf file");
read_config('./settings-02.conf', $GLOBAL_ACTIONS);
say("VERBOSITY: $VERBOSITY");
say("DEBUG: $DEBUG");
say("WORKING DIRECTORY: ", getcwd);
