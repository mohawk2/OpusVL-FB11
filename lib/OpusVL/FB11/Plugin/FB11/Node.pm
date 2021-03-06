package OpusVL::FB11::Plugin::FB11::Node;

=head1 NAME

OpusVL::FB11::Plugin::FB11::Node - Represents a node in the access tree

=head1 DESCRIPTION

The L<OpusVL::FB11::Plugin::FB11::FeatureList> comprises these things.

=cut

use Moose;

has node_name       => ( is => 'rw'       , isa => 'Str'                     , required => 1 );

# Controller (if any) linked to this node..
has controller      => ( is => 'rw'       , isa => 'Catalyst::Controller'    );

# Action Path (if any) linked to this node..
has action_path     => ( is => 'rw'       , isa => 'Str'                     );

# Array of roles that can access this node..
has access_only     => ( is => 'rw'       , isa => 'ArrayRef'                );

# Hash of attributes..
has action_attrs    => ( is => 'rw'       , isa => 'HashRef'                 );

has in_feature      => ( is => 'rw', isa => 'Bool', required => 1 );

# maybe for future use?.... currently being delt with in the Base::Controller::GUI...
#   has navigation      => ( is => 'rw'       , isa => 'Int'                     , default  => 0 );
#   has navigation_name => ( is => 'rw'       , isa => 'Str'                     );
#   has home_navigation => ( is => 'rw'       , isa => 'Int'                     , default  => 0 );
#   has portlet         => ( is => 'rw'       , isa => 'Int'                     , default  => 0 );
#   has portlet_name    => ( is => 'rw'       , isa => 'Str'                     );

1;
__END__
