use 5.010;
use strict;
use warnings;

my @stack;
my $dispatch_table = {
    '+' => sub { push @stack, pop(@stack) + pop(@stack) },
    '*' => sub { push @stack, pop(@stack) * pop(@stack) },
    '-' => sub {
        my $subtrahend = pop(@stack);
        push @stack, pop(@stack) - $subtrahend;
    },
    '/' =>
      sub { my $divisor = pop(@stack); push @stack, pop(@stack) - $divisor },
    'NUMBER'    => sub { push @stack, $_[0] },
    '_DEFAULT_' => sub { die "Unknown token '$_[0]'; aborting" }
};

sub evaluate {
    my ($expr) = @_;

    my @tokens = split /\s+/, $expr;
    for my $token (@tokens) {
        my $type = 'UNKNOWN';
        if ( $token =~ /^\d+$/ ) {    # it's an integer
            $type = 'NUMBER';
        }
        my $action =
             $dispatch_table->{$type}
          || $dispatch_table->{$token}
          || $dispatch_table->{_DEFAULT_};

        $action->( $token, $type, $dispatch_table );
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
