use 5.010;
use strict;
use warnings;

use Text::Fuzzy;
use Cwd 'getcwd';

our $GLOBAL_VARS = {
    'VERBOSITY' => 0,
    'DEBUG' => 0,
};

our $GLOBAL_ACTIONS = {
    'CHDIR' => \&change_dir,
    'LOGFILE' => \&open_log_file,
    'DEFINE' => \&define_config_directive,
    'VERBOSITY' => \&set_variable,
    'DEBUG' => \&set_variable,
    'HISTORY' => \&open_input_file,
    'TEMPLATE' => \&open_input_file,
    '_DEFAULT_' => \&no_such_directive_retry,
};

sub read_config {
    my ($filename, $dispatch_table, $user_context) = @_;

    open my ($file), $filename or do {
        warn "Cannot open configuration file $filename: $!; SKIPPING...";
        return;
    };
    while (<$file>) {
        chomp; # trim newlines
        my ($directive, $rest) = split /\s+/, $_, 2;
        my $action = $dispatch_table->{$directive} || $dispatch_table->{_DEFAULT_};
        $action->($directive, $rest, $dispatch_table, $user_context, $filename);
    }
    return 1;
}

sub change_dir {
    my ($directive, $dir) = @_;
    chdir($dir)
        or die "Couldn't chdir to '$dir': $!; aborting";
}

sub open_log_file {
    my ($directive, $filename) = @_;
    open STDERR, ">>", $filename
        or die "Couldn't open log file '$filename': $!; aborting";
}

sub set_variable {
    # the 3rd parameter is the dispatch table
    my ($variable, $value, undef, $config_hash) = @_;
    $config_hash->{$variable} = $value;
}

sub define_config_directive {
    my ($directive, $rest, $dispatch_table, $user_context) = @_;

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

sub open_input_file {
    my ($handle, $filename, $dispatch_table, $user_context) = @_;
    unless (open $user_context->{$handle}, $filename) {
        warn "Couldn't open $handle file '$filename': $!; ignoring.\n";
    }
}

sub no_such_directive {
    my ($directive, $rest, $dispatch_table, $user_context, $filename) = @_;
    warn "Unrecognized directive $directive at line $. of $filename; ignoring.\n";
}

sub no_such_directive_retry {
    my ($bad, $rest, $dispatch_table, $user_context, $filename) = @_;
    my ($best_match, $best_score);

    $best_score = 0.0;
    for my $good (keys %$dispatch_table) {
        my $score = score_match($bad, $good);
        if ($score > $best_score) {
            $best_score = $score;
            $best_match = $good;
        }
    }
    warn "Unrecognized directive $bad at line $. of $filename; ignoring.\n";
    warn "\t(perhaps you meant $best_match?)\n";
}

sub score_match {
    my ($bad, $good) = @_;
    my $text = Text::Fuzzy->new ($bad);
    return 1.0 / $text->distance($good);
}

say("Reading configuration from settings-03.conf file");
read_config('./settings-03.conf', $GLOBAL_ACTIONS, $GLOBAL_VARS);
say("VERBOSITY: $GLOBAL_VARS->{VERBOSITY}");
say("DEBUG: $GLOBAL_VARS->{DEBUG}");
say("WORKING DIRECTORY: ", getcwd);
