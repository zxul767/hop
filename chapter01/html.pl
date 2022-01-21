use 5.010;

use HTML::TreeBuilder;

my $html = "
<head>
  <title>This is a title.</title>
</head>
<body>
  <h1>This is a header.</h1>
  <p>This is a paragraph.</p>
  <p>This is another paragraph.</p>
  <div>
    <p>This is a nested paragraph</p>
  </div>
</body>";

my $tree = HTML::TreeBuilder->new;
$tree->ignore_ignorable_whitespace(0);
$tree->parse($html);
$tree->eof();

sub untag_html {
    my ($html) = @_;
    return $html unless ref $html; # it's a plain string

    my $text = '';
    for my $item (@{$html->{_content}}) {
        $text .= untag_html($item);
    }
    return $text;
}

say("Plain text in HTML string: ");
say(untag_html($tree));

sub walk_html {
    my ($html, $visit_text, $visit_node) = @_;
    return $visit_text->($html) unless ref $html; # it's a plain string

    my @results;
    for my $item (@{$html->{_content}}) {
        push @results, walk_html($item, $visit_text, $visit_node);
    }
    return $visit_node->($html, @results);
}

say("Plain text in HTML string: ");
say(walk_html($tree, sub { $_[0] }, sub { shift; join '', @_ }));

sub print_if_h1 {
    my $element = shift;
    my $text = join '', @_;
    print $text if $element->{_tag} eq 'h1';
    return $text;
}
say("All headers: ");
walk_html($tree, sub { $_[0] }, \&print_if_h1);
say();

sub extract_headers {
    my $tree = shift;
    my @tagged_texts = walk_html($tree, sub { ['maybe', $_[0]] }, \&promote_if_h1);
    my @keepers = grep { $_->[0] eq 'keeper' } @tagged_texts;
    my @keeper_text = map { $_->[1] } @keepers;
    my $header_text = join '', @keeper_text;
    return $header_text;
}

# sub promote_if_h1 {
#     my $element = shift;
#     if ($element->{_tag} eq 'h1') {
#         return ['keeper', join '', map {$_->[1]} @_];
#     }
#     return @_;
# }

sub promote_if_h1 {
    promote_if(sub { $_[0]->{_tag} eq 'h1' }, @_);
}

sub promote_if {
    my $is_interesting = shift;
    my $element = shift;

    if ($is_interesting->($element)) {
        return ['keeper', join('', map { $_->[1] } @_)];
    }
    return @_;
}

say("All headers: ");
say(extract_headers($tree));
