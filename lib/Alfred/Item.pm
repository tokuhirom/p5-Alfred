use strict;
use warnings;

package Alfred::Item;
use Carp;

sub new {
    my $class = shift;
    my %args = @_;
    my $title = delete($args{title}) // croak "Missing title";
    my $subtitle = delete($args{subtitle}) // croak "Missing subtitle";
    bless {
        attr => \%args,
        title => $title,
        subtitle => $subtitle,
    }, $class;
}

sub as_xml {
    my $self = shift;
    
    my $item = Alfred::XML->new(tag => 'item', attr => $self->{attr});
    $item->add_child(Alfred::XML->new(tag => 'title', content => $self->{title}));
    $item->add_child(Alfred::XML->new(tag => 'subtitle', content => $self->{subtitle}));
    return $item;
}

1;