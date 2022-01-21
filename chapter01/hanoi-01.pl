use 5.010;

sub hanoi {
    my ( $disks, $start, $end, $extra ) = @_;

    if ( $disks == 1 ) {
        say("Move disk #1 from $start to $end.");
    }
    else {
        hanoi( $disks - 1, $start, $extra, $end );
        say("Move disk #$disks from $start to $end.");
        hanoi( $disks - 1, $extra, $end, $start );
    }
}

say("Tower of Hanoi Puzzle (N = 3)");
hanoi( 3, 'A', 'B', 'C' )
