package TestApp::Fixtures::Auth;

sub admin_role {
    my $schema = shift;
    my $app = shift;
    my $admin_role = $schema->resultset('Role')->create( { role => 'Administrator' } );
    my $feature_list = $app->fb11_features->feature_list;

    for my $section (keys %$feature_list) {
        my $roles = $feature_list->{$section};

        for my $role (keys %$roles) {
            $schema->resultset('Aclfeature')->find_or_create({
                feature => $section . '/' . $role
            });
        }
    }
    $schema->schema->txn_do(sub {
        for my $feature ( $schema->resultset('Aclfeature')->all ) {
            $admin_role->add_to_aclfeatures($feature)
                unless $admin_role->aclfeatures->find($feature->id);
        }
    });

    return $admin_role;
}

sub admin_user {
    my $schema = shift;
    my $admin_role = shift;

    my $user = $schema->resultset('User')->search( {username => 'fb11admin'} );

    unless ($user) {
        my $user = $schema->resultset('User')->create({
            username => 'fb11admin',
            email    => 'fb11admin@localhost',
            name     => 'Administrator',
            password => 'password',
        });

        $user->add_to_roles($admin_role) if $admin_role;
    }

    return $user;
}

1;
