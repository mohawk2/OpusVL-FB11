package TestApp::Fixtures;

use strict;
use warnings;
use OpusVL::FB11::DeploymentHandler;
use File::ShareDir 'module_dir';
use v5.24;

sub deploy_auth_schema {
    my $schema = shift;
    my $dh = OpusVL::FB11::DeploymentHandler->new({
        schema => $schema,
        script_directory => module_dir('OpusVL::FB11::Schema::FB11AuthDB') . '/sql',
        to_version => $schema->schema_version,
    });

    # Auth schema installs version storage. IT is the FB11 core schema.
    # We do the test so you can reuse a stored db with FB11_TEST_SQLITE_DB
    unless ($dh->version_storage_is_installed) {
        my $ddl = $dh->deploy({
            version => 1
        });
        $dh->add_database_version({
            version => 1,
            ddl => $ddl,
        });
    }
    $dh->upgrade;
}

1;
