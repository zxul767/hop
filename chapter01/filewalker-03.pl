use 5.010;

sub walk_folder {
    my ($top, $visit_file, $visit_folder) = @_;

    if (-d $top) {
        my $folder;
        unless (opendir $folder, $top) {
            warn "Couldn't open directory $top: $!; skipping.\n";
            return;
        }
        my @results;
        while (my $file = readdir $folder) {
            next if $file eq '.' || $file eq '..';
            push @results, walk_folder("$top/$file", $visit_file, $visit_folder);
        }
        return $visit_folder ? $visit_folder->($top, @results) : ();
    } else {
        return $visit_file ? $visit_file->($top) : ();
    }
}

sub file_size { -s $_[0] }

sub folder_size {
    my $folder = shift;
    my $total = -s $folder;
    for my $file_size (@_) {
        $total += $file_size
    }
    return $total;
}

$total_size = walk_folder('.', \&file_size, \&folder_size);
say("Current folder has size: $total_size (bytes)");

sub print_folder_size {
    my $folder = shift;
    my $size = folder_size($folder, @_);
    printf("%6d %s\n", $size, $folder);
    return $size;
}

say("Sizes of sub-directories:");
$total_size = walk_folder('.', \&file_size, \&print_folder_size);
say();

sub process_file {
    my $file = shift;
    return [shorten_filepath($file), -s $file];
}

sub process_folder {
    my ($folder, @subfolders) = @_;
    my %new_hash;
    for (@subfolders) {
        my ($subfolder_name, $subfolder_structure) = @$_;
        $new_hash{$subfolder_name} = $subfolder_structure;
    }
    return [shorten_filepath($folder), \%new_hash];
}

sub shorten_filepath {
    my $path = shift;
    # remove everything up to the last '/' character
    $path =~ s{.*/}{};
    return $path;
}

my $result = walk_folder('.', \&process_file, \&process_folder);
my ($name, $structure) = @$result;
# $structure is reference to a hash with all the keys under $name
say("Files and folders directly under current folder: ");
say(join("\n", keys(%$structure)));
say();

sub print_filename { say("$_[0]") }
say("All files under current folder (recursively): ");
walk_folder('.', \&print_filename, \&print_filename);
say();

sub print_if_dangling_link {
    my $file = shift;
    say("$file") if -l $file && ! -e $file;
}
say("All dangling links: ");
walk_folder('.', \&print_if_dangling_link, sub {});
say();

@all_plain_files = walk_folder('.', sub { $_[0] }, sub { shift; return @_ });
say("All files (full paths) under current folder (recursively): ");
say(join("\n", @all_plain_files));
