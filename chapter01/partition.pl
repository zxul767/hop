use 5.010;

sub find_share {
    my ( $target, $treasures ) = @_;

    return [] if $target == 0;
    return    if $target < 0 || @$treasures == 0;

    my ( $first, @rest ) = @$treasures;
    my $solution = find_share( $target - $first, \@rest );
    return [ $first, @$solution ] if $solution;
    return find_share( $target, \@rest );
}

my $target = 10;
say("Finding partition that sums up to $target: ");
say( join ' ', @{ find_share( $target, [ 1, 2, 4, 8 ] ) } );

sub sum {
    my ($numbers) = @_;

    # say("suming numbers: ", join ',', @$numbers);
    my $total = 0;
    for my $number (@$numbers) {
        $total += $number;
    }
    return $total;
}

sub partition {
    my $total  = sum( [@_] );
    my $share1 = find_share( $total / 2, [@_] );
    return unless defined $share1;

    my %in_share1;
    for my $treasure (@$share1) {
        ++$in_share1{$treasure};
    }

    my $share2;
    for my $treasure (@_) {
        if ( $in_share1{$treasure} ) {
            --$in_share1{$treasure};
        }
        else {
            push @$share2, $treasure;
        }
    }
    return ( $share1, $share2 );
}

say("Partitioning:");
my ( $share1, $share2 ) = partition( 1, 2, 4, 8, 3, 2 );
if ( defined $share1 && defined $share2 ) {
    my $total = sum($share1);
    say("Divided original treasure into two parts summing up to: $total");
    say( "First share: ",  join ',', @$share1 );
    say( "Second share: ", join ',', @$share2 );
}
else {
    say("Cannot find partition!");
}
