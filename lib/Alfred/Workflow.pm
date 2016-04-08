use strict;
use warnings;

# https://www.alfredapp.com/help/workflows/inputs/script-filter/

package Alfred::Workflow;
use Alfred::Item;
use Alfred::XML;
use Carp;
use Scalar::Util qw/blessed/;

sub new {
    my $class = shift;
    bless {
        items => [],
    }, $class;
}

sub add_item {
    my ($self, $item) = @_;
    blessed($item) or croak "Item should be instance of Alfred::Item";
    
    push @{$self->{items}}, $item;
}

sub as_xml {
    my $self = shift;
    
    my $xml = Alfred::XML->new(tag => 'items');
    for my $item (@{$self->{items}}) {
        $xml->add_child($item->as_xml);
    }
    return $xml;
}

sub as_string {
    my $self = shift;

    return join("\n",
        q{<?xml version="1.0"?>},
        $self->as_xml->as_string
    );
}

1;