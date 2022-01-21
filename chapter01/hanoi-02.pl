use 5.010;

sub hanoi {
    my ( $disks, $start, $end, $extra, $move_disk ) = @_;

    if ( $disks == 1 ) {
        $move_disk->( 1, $start, $end );
    }
    else {
        hanoi( $disks - 1, $start, $extra, $end, $move_disk);
        $move_disk->( $disks, $start, $end );
        hanoi( $disks - 1, $extra, $end, $start, $move_disk);
    }
}

sub print_instruction {
    my ( $disk, $start, $end ) = @_;
    say("Move disk #$disk from $start to $end");
}

say("Tower of Hanoi Puzzle (N = 3)");
hanoi( 3, 'A', 'B', 'C', \&print_instruction );
say();

# Tower of disks is initially on peg 'A'
@disk_position = ('', 'A', 'A', 'A');

sub check_move {
    my ( $disk, $start, $end ) = @_;
    if ($disk < 1 || $disk > $#disk_position) {
        die "Bad disk number $disk. Should be 1..$#disk_position.\n";
    }
    unless ($disk_position[$disk] eq $start) {
        die "Tried to move disk $disk from $start but it's on peg $disk_position[$disk].\n";
    }
    for my $i (1 .. $disk-1) {
        if ($disk_position[$i] eq $start) {
            die "Can't move disk $disk from $start because $i is on top of it.\n";
        } elsif ($disk_position[$i] eq $end) {
            die "Can't move disk $disk to $end because $i is already there.\n";
        }
    }
    say("Moving disk $disk from $start to $end.");
    $disk_position[$disk] = $end;
}

say("Tower of Hanoi Puzzle (N = 3)");
hanoi( 3, 'A', 'B', 'C', \&check_move );
