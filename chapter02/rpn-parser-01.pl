use 5.010;
use strict;
use warnings;

my @stack;
my $dispatch_table = {
    'NUMBER'    => sub { push @stack, $_[0] },
    '_DEFAULT_' => sub {
        my $operand = pop(@stack);
        push @stack, [ $_[0], pop(@stack), $operand ];
    }
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

sub AST_to_string {
    my ($tree) = @_;
    if ( ref $tree ) {
        my ( $operator, $arg1, $arg2 ) = @$tree;
        my ( $s1, $s2 ) = ( AST_to_string($arg1), AST_to_string($arg2) );
        return "($s1 $operator $s2)";
    }
    return $tree;
}

# RPN stands for Reverse Polish Notation.
# Some examples you may try are:
# 3 4 * => 12
# 1 2 + 4 * => 12
# 3 2 - 11 + => 12
my $ast = evaluate( $ARGV[0] );
say( AST_to_string($ast) );
