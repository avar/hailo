package Hailo::Tokenizer::MegaHAL;

use 5.010;
use Any::Moose;
BEGIN {
    return unless Any::Moose::moose_is_preferred();
    require MooseX::StrictConstructor;
    MooseX::StrictConstructor->import;
}
use namespace::clean -except => 'meta';

with qw(Hailo::Role::Arguments
        Hailo::Role::Tokenizer);

# input -> tokens
sub make_tokens {
    my ($self, $line) = @_;

    my @chunks = $line =~ m/([a-zA-Z0-9']+)/g;
    map { tr/a-z/A-Z/ } @chunks;
    push @chunks => '.' unless $chunks[-1] eq '.';

    my @tokens = map { [ $self->spacing->{normal}, $_ ] } @chunks;

    return \@tokens;
}

# tokens -> output
sub make_output {

}

__PACKAGE__->meta->make_immutable;

=encoding utf8

=head1 NAME

Hailo::Tokenizer::MegaHAL - A tokenizer for L<Hailo|Hailo> which splits
on whitespace, mostly.

=head1 DESCRIPTION

This tokenizer does its best to handle various languages. It knows about most
apostrophes, quotes, and sentence terminators.

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason.

This program is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
