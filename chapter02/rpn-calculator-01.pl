use 5.010;
use strict;
use warnings;

sub evaluate {
    my ($expr) = @_;

    my @stack;
    my @tokens = split /\s+/, $expr;
    for my $token (@tokens) {
        if ( $token =~ /^\d+$/ ) {    # it's an integer
            push @stack, $token;
        }
        elsif ( $token eq '+' ) {
            push @stack, pop(@stack) + pop(@stack);

        }
        elsif ( $token eq '-' ) {
            my $subtrahend = pop(@stack);
            push @stack, pop(@stack) - $subtrahend;

        }
        elsif ( $token eq '*' ) {
            push @stack, pop(@stack) * pop(@stack);

        }
        elsif ( $token eq '/' ) {
            my $divisor = pop(@stack);
            push @stack, pop(@stack) / $divisor;
        }
        else {
            die "Unrecognized token '$token'; aborting";
        }
    }
    return pop(@stack);
}

# RPN stands for Reverse Polish Notation.
# Some examples you may try are:
# 3 4 * => 12
# 1 2 + 4 * => 12
# 3 2 - 11 + => 12
my $result = evaluate( $ARGV[0] );
say("Result: $result");
