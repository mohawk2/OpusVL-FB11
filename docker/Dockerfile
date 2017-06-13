FROM quay.io/opusvl/catalyst-dbic
MAINTAINER Alastair McGowan-Douglas <alastair.mcgowan@opusvl.com>

RUN /opt/perl5/bin/cpanm -M http://cpan.opusvl.com OpusVL::FB11 Starman

# This is being manually updated until the changes are merged upstream.
# This allows us to have one DH per schema instead of trying to merge all our
# schemata together
COPY DBIx-Class-DeploymentHandler-0.002219.tar.gz /
RUN /opt/perl5/bin/cpanm /DBIx-Class-DeploymentHandler-0.002219.tar.gz \
    && rm /DBIx-Class-DeploymentHandler-0.002219.tar.gz

COPY entrypoint.pl /
RUN mkdir /opt/fb11 \
    && useradd --home /opt/fb11 fb11 \
    && chown -R fb11: /opt/fb11

ENV PERL5LIB /opt/fb11

USER fb11

ENTRYPOINT [ "/entrypoint.pl" ]
