use 5.010;

sub factorial {
    my ($number) = @_;

    return 1 if $number == 0;
    return factorial( $number - 1 ) * $number;
}

@numbers = ( 0, 1, 2, 3, 5, 8, 13, 21, 34, 55 );

say("Factorial Computation: ");
for my $i (@numbers) {
    say( "$i! = ", factorial($i) );
}
