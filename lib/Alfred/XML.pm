use strict;
use warnings;

package Alfred::XML;
use Carp;
use Scalar::Util qw/blessed/;

our $LEVEL;

my %quotes = (
    q{"} => "&quot;",
    q{'} => "&apos;",
    q{<} => "&lt;",
    q{>} => "&gt;",
    q{&} => "&amp;",
);

sub escape {
    local $_ = shift;
    s/(["'<>&])/$quotes{$1}/ge;
    return $_;
}

sub new {
    my $class = shift;
    my %args = @_;
    my $tag = delete($args{tag}) or croak "Missing tag";

    bless {
        tag => $tag,
        children => [],
        %args
    }, $class;
}

sub add_child {
    my ($self, $child) = @_;
    push @{$self->{children}}, $child;
}

sub as_string {
    my $self = shift;
    local $LEVEL = -1;
    return $self->_as_string();
}

sub _as_string {
    my $self = shift;
    
    local $LEVEL = $LEVEL + 1;

    my $buf;
    $buf .= "\t" x $LEVEL;
    $buf .= "<" . $self->{tag} . ' ';
    $buf .= join " ",
        map { escape($_) . '="' . escape($self->{attr}->{$_}) . '"' }
        sort keys %{$self->{attr}};
    $buf .= ">";
    if (exists $self->{content}) {
        $buf .= escape($self->{content});
    } elsif (exists $self->{children}) {
        $buf .= "\n";
        for my $child (@{$self->{children}}) {
            $buf .= $child->_as_string();
        }
        $buf .= "\t" x $LEVEL;
    }

    $buf .= "</" . $self->{tag} . ">\n";
    
    return $buf;

}

1;