package Hailo::Storage::PostgreSQL;

use 5.010;
use strict;
use parent 'Hailo::Storage';

sub dbd { 'Pg' };

sub dbd_options {
    my ($self) = @_;
    return {
        %{ $self->SUPER::dbd_options },
        pg_enable_utf8 => 1,
    };
}

sub dbi_options {
    my ($self) = @_;
    my $dbd = $self->dbd;
    my $dbd_options = $self->dbd_options;
    my $args = $self->arguments;

    my $conn_line = "dbi:$dbd";
    $conn_line .= ":dbname=$args->{dbname}"  if exists $args->{dbname};
    $conn_line .= ";host=$args->{host}"    if exists $args->{host};
    $conn_line .= ";port=$args->{port}"    if exists $args->{port};
    $conn_line .= ";options=$args->{options}" if exists $args->{options};

    my @options = (
        $conn_line,
        ($args->{username} || ''),
        ($args->{password} || ''),
        $dbd_options,
    );

    return \@options;
}

sub _exists_db {
    my ($self) = @_;
    $self->sth->{exists_db}->execute();
    return int $self->sth->{exists_db}->fetchrow_array;
}

sub ready {
    my ($self) = @_;

    return exists $self->arguments->{dbname};
}

1;

=encoding utf8

=head1 NAME

Hailo::Storage::PostgreSQL - A storage backend for L<Hailo|Hailo> using L<DBD::Pg>

=head1 SYNOPSIS

First create a PostgreSQL database for failo:

    # Run it as a dedicated hailo user
    createdb -E UTF8 -O hailo hailo

    # Just create database..
    createdb -E UTF8 hailo

As a module:

    my $hailo = Hailo->new(
        storage_class => 'Pg',
        storage_args => {
            dbname   => 'hailo',
        },
    );
    $hailo->train("hailo.trn");

Or with complex connection options:

    my $hailo = Hailo->new(
        storage_class => 'Pg',
        storage_args => {
            dbname   => 'hailo',
            host     => 'localhost',
            port     => '5432',
            options  => '...',
            username => 'hailo',
            password => 'hailo'
        },
    );
    $hailo->train("hailo.trn");

From the command line:

    hailo --train hailo.trn \
        --storage      Pg \
        --storage-args dbname=hailo

Or with complex connection options:

    hailo --train hailo.trn \
        --storage      Pg \
        --storage-args dbname=hailo \
        --storage-args host=localhost \
        --storage-args port=5432 \
        --storage-args options=... \
        --storage-args username=hailo \
        --storage-args password=hailo

Almost all of these options can be omitted, see L<DBD::Pg's
documentation|DBD::Pg/"connect"> for the default values.

See L<Hailo's documentation|Hailo> for other non-Pg specific options.

=head1 DESCRIPTION

This backend maintains information in a PostgreSQL database.

=head1 ATTRIBUTES

=head2 C<storage_args>

This is a hash reference which can have the following keys:

B<'dbname'>, the name of the database to use (required).

B<'host'>, the host to connect to (required).

B<'port'>, the port to connect to (required).

B<'options'>, additional options to pass to PostgreSQL.

B<'username'>, the username to use.

B<'password'>, the password to use.

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason.

This program is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
