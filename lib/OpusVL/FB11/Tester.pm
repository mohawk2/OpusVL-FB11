package OpusVL::FB11::Tester;

use Moose;
use Test::Builder;
use Test::LongString;
use Mojo::DOM;
use Switch::Plain;
use File::Slurper qw(write_text);
extends 'Test::WWW::Mechanize::Catalyst';

my $TB = Test::Builder->new;

sub dump {
    my $self = shift;
    my ($filename) = $self->uri->path =~ m{([^/]+)$};

    write_text($filename, $self->content(decoded_by_headers => 1))
}

sub dom {
    my $self = shift;
    my $dom = Mojo::DOM->new($self->response->decoded_content);
}

# Generate all the x_message_y methods. They all work basically the same
sub __cmp {
    ## Calls $meth on $self to get the string
    ## Then compares it using $cmptype_string from Test::LongString
    ## to $str, with $desc as the test description
    my $self = shift;
    my $meth = shift;
    my $cmptype = shift;
    my $str = shift;
    my $desc = shift;

    my $cmpref = do { no strict 'refs'; \&{"${cmptype}_string"} };

    return $cmpref->( $self->$meth, $str, $desc );
}

my $meta = __PACKAGE__->meta;

for my $cmptype (qw/contains lacks like unlike/) {
    for my $msgtype (qw/error status/) {
        $meta->add_method(
            qq(${msgtype}_message_$cmptype) => sub {
                my $self = shift;
                my $str = shift;
                my $desc = shift // ucfirst $msgtype . qq{ message $cmptype "$str"};;
                $self->__cmp("${msgtype}_message", $cmptype, $str, $desc);
            }
        );
    }

    $meta->add_method(
        qq(field_error_message_$cmptype) => sub {
            my $self = shift;
            my $field_name = shift;

            # Google madness with methods
            $self->__cmp(sub { $self->field_error_message($field_name) }, $cmptype, @_);
        }
    );
}

sub status_message {
    my $self = shift;
    my $dom = $self->dom;

    my $alert = $dom->find('div.fb11-main-content div.alert.alert-info')->first;
    return '' if not $alert;
    return $alert->all_text;
}

sub error_message {
    my $self = shift;
    my $dom = $self->dom;

    my $alert = $dom->find('div.fb11-main-content div.alert.alert-danger')->first;
    return '' if not $alert;
    return $alert->all_text;
}

sub field_error_message {
    my $self = shift;
    my $field = shift;

    my $dom = $self->dom;
    my $help_block = $dom->find(qq([name="$field"] + span.help-block))->first;
    return '' if not $help_block;
    return $help_block->all_text;

}

1;

=head1 DESCRIPTION

Extends L<Test::WWW::Mechanize::Catalyst> to understand conventions about an
FB11 application, thus making it easier to write a test that actually asks
relevant FB11 questions.

Hopefully the L</METHODS> will make that sentence clearer.

=head1 METHODS

=head2 dump

Dumps the content into a file in PWD named after the URL of the request that
formed it.

=head2 dom

Returns a Mojo::DOM object for the body of the page, assuming it's HTML.

=head2 error_message

=head2 status_message

Gets the relevant message from the page, or the empty string if there is no such
status. This makes it easier to run tests, which is the point.

    ok ($mech->error_message, "An error happened!");

=head2 error_message_contains

=head2 error_message_lacks

=head2 status_message_contains

=head2 status_message_lacks

B<Arguments>: C<$str>, C<$desc>?

Tests that the specified message contains the C<$str>, or lacks it. Remember
this will not complain if the message does not exist.

Uses C<$desc>, if provided, as the test remark.

    $mech->error_message_contains("Access Denied", "Access was denied");

=head2 error_message_like

=head2 error_message_unlike

=head2 status_message_like

=head2 status_message_unlike

B<Arguments>: C<$regex>, C<$desc>?

Tests that the relevant message matches, or does not match, the given C<$regex>.
Remember this will not complain if the message doesn't exist.

    $mech->error_message_like(qr/access denied|you have to login/i, "Access was denied");

=head2 field_error_message

B<Arguments>: C<$field_name>

Returns the error message for the given field, or the empty string. Only returns
the string if the field has the C<has-error> class, since the C<help-block> span
after a field could be something else if the field doesn't label itself as
having an error.

=head2 field_error_message_contains

=head2 field_error_message_lacks

B<Arguments>: C<$field_name>, C<$str>, C<$desc>?

Compares the error message on the given field to C<$str>, with C<$desc> as the
optional test remark.

    $mech->field_error_message_contains('password', "Wrong username or password");

=head2 field_error_message_like

=head2 field_error_message_unlike

B<Arguments>: C<$field_name>, C<$regex>, C<$desc>?

Compares the error message on the given field to C<$regex>, with C<$desc> as the
optional test remark.

    $mech->field_error_message_like('password', qr/^Wrong /i);
