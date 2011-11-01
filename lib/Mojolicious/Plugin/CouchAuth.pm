package Mojolicious::Plugin::CouchAuth;

use Mojo::Base 'Mojolicious::Plugin';
use Store::CouchDB;
use Digest::SHA qw(sha256_base64);

our $VERSION = '1.0';

sub register {
    my ( $self, $app, $params ) = @_;
    my $couch = Store::CouchDB->new(
        port => $params->{port},
        db   => $params->{db}
    );

    $app->helper(
        auth => sub {
            my ($self) = @_;

            return 1 if $self->session->{name};
            my $doc = _get_user($couch, $self->param('username'));
            return unless $doc;

            if (sha256_base64( $self->param('password') ) eq $doc->{password}){
                $self->session(name => $doc->{name});
                $self->session(user_id => $doc->{_id});
                $self->session(admin => 1) if (defined $doc->{role} && $doc->{role} eq 'admin');
                $self->session(last_login => _set_last_login($couch, $doc));
                return 1
            }
        },
        is_admin => sub  {
            my ($self) = @_;

            my $doc = _get_user($couch, $self->param('username'));
            return unless $doc;

            return 1
              if (defined $doc->{role} && $doc->{role} eq 'admin');
        }
    );
}

sub _get_user {
    my ($couch, $user) = @_;
    my $docs = $couch->get_view({
            view   => 'site/user',
            opts   => { key => '"' . $user . '"' }
        });
    return $docs->{ $user };
}

sub _set_last_login {
    my ($couch, $doc) = @_;

    my $last_login = $doc->{last_login};
    $doc->{last_login} = time;
    $couch->put_doc({name => $doc->{_id}, doc => $doc});
    return $last_login;
}

1;
