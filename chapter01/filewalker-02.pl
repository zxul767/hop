use 5.010;

sub walk_folder {
    my ( $top, $visit ) = @_;

    $visit->($top);

    # process recursively only if it's a folder
    if ( -d $top ) {

        # the file handle bound to `$dir` will automatically get closed
        # upon the termination of its scope (i.e., at the end of this block)
        my $dir;
        unless ( opendir $dir, $top ) {
            warn "Couldn't open directory $top: $!; skipping.\n";
            return;
        }
        my $file;
        while ( $file = readdir $dir ) {
            next if $file eq '.' || $file eq '..';
            walk_folder( "$top/$file", $visit );
        }
    }
}

# This is one way to use the `walk_folder` function
#
# sub print_folder {
#     say($_[0])
# }
# walk_folder('.', \&print_folder);

# When a function is so simple, an anonymous function is better:
say("All files under the current folder: ");
walk_folder( '.', sub { say( $_[0] ) } );
say();

say("All files (and their sizes in bytes) under the current folder: ");
walk_folder( '.', sub { printf( "%6d %s\n", -s $_[0], $_[0] ) } );
say();

say("All dangling symbolic links: ");
walk_folder( '.', sub { say("$_[0]") if -l $_[0] && !-e $_[0] } );
say();

my $total = 0;
walk_folder( '.', sub { $total += -s $_[0] } );
say("Total size of all files under the current folder is $total bytes.")
