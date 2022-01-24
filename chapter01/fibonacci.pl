use 5.010;

sub fib {
    my ($month) = @_;
    if ( $month < 2 ) { 1 }
    else {
        fib( $month - 1 ) + fib( $month - 2 );
    }
}

say("Fibonacci Computation: ");
for my $i ( 1 .. 10 ) {
    say( "fib($i) = ", fib($i) );
}
