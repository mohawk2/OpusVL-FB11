package OpusVL::FB11;

=head1 NAME

OpusVL::FB11 - Catalyst based application

=head1 SYNOPSIS

    You use inherite the OpusVL::FB11 by making the following files to your MyApp.

    F<MyApp.pm>:

        package MyApp;
        use strict;
        use warnings;
        use MyApp::Builder;
        
        MyApp::Builder->new(appname => __PACKAGE__)->bootstrap;

    F<MyApp/Builder.pm>:

        package MyApp::Builder;
        use Moose;
        extends 'OpusVL::FB11::Builder';
        override _build_superclasses => sub 
        {
            return [ 'OpusVL::FB11' ]
        };

    F<myapp.conf>:
    
        <OpusVL::FB11::Plugin::FB11>
            access_denied   "access_notallowed"
            <acl_rules>
                somecontroller/someaction       "somerole"
                somecontroller/someaction       "someotherrole"
                somecontroller/someotheraction  "somerole"
            </acl_rules>
        </OpusVL::FB11::Plugin::FB11>
  


=head1 DESCRIPTION

    This is a Catalyst Application that was built with the intention of being inherited by using AppBuilder.

    You can do 2 things with thie application:
        1. Enable your catalyst app to use it.
        2. Add your catalyst app to it.

    The SYNOPSIS above shows how your can enable your catalyst app to use it (option 1).

    For option 2 .. Add your catalyst app to it.. see OpusVL::FB11::Base::Controller::GUI.

=head1 SEE ALSO

    L<OpusVL::FB11::Plugin::FB11>,
    L<OpusVL::FB11::Base::Controller::GUI>,
    L<OpusVL::FB11::Controller::Root>, 
    L<Catalyst>

=head1 AUTHOR

    OpusVL - www.opusvl.com

=head1 COPYRIGHT and LICENSE

Copyright (C) 2010 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

##################################################################################################################################
# use lines #
##################################################################################################################################

use strict;
use warnings;
use OpusVL::FB11::Builder;
use OpusVL::FB11::Hive;
use Moose;
our $VERSION = '0.043';

##################################################################################################################################
# main #
##################################################################################################################################

# Make the Builder object and run the ->bootstrap so this becomes a AppBuilder inheritable application.. see: 
#   OpusVL::FB11::Builder 
#   CatalystX::AppBuilder

my $builder = OpusVL::FB11::Builder->new( appname => __PACKAGE__, version => $VERSION );
$builder->bootstrap;

##################################################################################################################################
1;
