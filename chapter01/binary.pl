use 5.010;

sub to_binary {
    my ($number) = @_;

    return $number if $number == 0 || $number == 1;

    my $lsb  = $number % 2;
    my $rest = to_binary( int( $number / 2 ) );

    return $rest . $lsb;
}

@numbers = ( 0, 1, 2, 3, 5, 8, 13, 21, 34, 55 );

say("Binary Conversion: ");
for my $i (@numbers) {
    say( "to_binary($i) = ", to_binary($i) );
}
