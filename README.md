# p5-Alfred

Alfred workflow library for perl5.

## Getting started.

 * Copy lib/ into your workflow directory.

Write your script:

    use strict;
    use FindBin;
    use lib "$FindBin::Bin/lib";
    use Alfred::Workflow;

    my @items = qw(a b c);
    
    my $query = shift;
    my $wf = Alfred::Wokflow->new();
    for (@items) {
        if (defined($query) && !/$query/) {
            next;
        }

        $wf->add_item(
            Alfred::Item->new(
                arg => $_,
                title => $_,
                subtitle => $_,
            )
        );
    }

    print $wf->as_string;

And set the workflow type as bash.
Put following command:

    /usr/bin/perl my-plugin.pl "{query}"

