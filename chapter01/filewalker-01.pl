use 5.010;

sub total_size {
    my ($top) = @_;
    my $total = -s $top;

    return $total if -f $top;
    my $dir;
    unless ( opendir $dir, $top ) {
        warn "Couldn't open directory $top: $!; skipping.\n";
        return $total;
    }
    my $file;
    while ( $file = readdir $dir ) {
        next if $file eq '.' || $file eq '..';
        $total += total_size("$top/$file");
    }
    closedir $dir;
    return $total;
}

say(
    "Total size of ~/Downloads: ",
    total_size("/home/zxul767/Downloads"),
    " bytes"
  )
