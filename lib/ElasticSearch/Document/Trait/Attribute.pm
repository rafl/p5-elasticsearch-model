package ElasticSearch::Document::Trait::Attribute;
use Moose::Role;
use ElasticSearch::Document::Mapping;

has property => ( is => 'ro', isa => 'Bool', default => 1 );

has id => ( is => 'ro', isa => 'Bool|ArrayRef', default => 0 );
has index  => ( is => 'ro' );
has boost  => ( is => 'ro', isa        => 'Num' );
has store  => ( is => 'ro', isa        => 'Str', default => 'yes' );
has type   => ( is => 'ro', isa        => 'Str', default => 'string' );
has parent => ( is => 'ro', isa        => 'Bool', default => 0 );
has dynamic => ( is => 'ro', isa        => 'Bool', default => 1 );
has analyzer => ( is => 'ro', isa => 'Str' );

sub is_property { shift->property }

sub build_property {
    my $self = shift;
    return { ElasticSearch::Document::Mapping::maptc($self, $self->type_constraint) };
}

before _process_options => sub {
    my ( $self, $name, $options ) = @_;
    $options->{required} = 1    unless ( exists $options->{required} );
    $options->{is}       = 'ro' unless ( exists $options->{is} );
    %$options = ( builder => 'build_id', lazy => 1, %$options )
      if ( $options->{id} && ref $options->{id} eq 'ARRAY' );
};

1;

__END__

=head1 ATTRIBUTES

B<< All attributes are C<required> and C<ro> by default. >>

=head2 property

This defaults to C<1> and marks the attribute as ElasticSearch
property and thus will be added to mapping. If you set this
to C<0> the attribute will act as a traditional Moose attribute.

=head2 id

Usually there is one property which also acts as id for the whole
document. If there is no attribute with the C<id> option defined
ElasticSearch will assign a random id. This option can either
be set to a true value or an arrayref. The former will make the
value of the attribute the id. The latter will generate a SHA1
digest of the concatenated values of the attributes listed in 
the arrayref.

Only one attribute with the C<id> option set can be present in 
a document.

=head2 type

Most of the time L<ElasticSearch::Document::Mapping> will take 
care of this option and set the correct value based on the
type constriant. In case it doesn't know what to do, this 
value will be used as the type for the attribute. Defaults
to C<string>.

=head1 PASS THROUGH ATTRIBUTES

The following attributes are passed thorugh - as is - to the
type mapping.

=head2 store

Defaults to C<yes>.

=head2 boost

=head2 index

=head2 dynamic

=head2 analyzer

=head1 METHODS

=head2 build_id

=head2 build_property

=head1 EXTENDING

