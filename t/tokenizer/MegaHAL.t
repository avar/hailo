use 5.010;
use autodie;
use strict;
use warnings;
use Test::More tests => 2;
use Hailo::Tokenizer::MegaHAL;

binmode $_, ':encoding(utf8)' for (*STDIN, *STDOUT, *STDERR);


    my $t = sub {
        my ($str, $tokens) = @_;

        my $toke = Hailo::Tokenizer::MegaHAL->new();
        my $parsed = $toke->make_tokens($str);
        my $tok;
        push @$tok, $_->[1] for @$parsed;

        diag("Expecting: " . (join ' ', map { qq[<<$_>>] } @$tokens));
        diag("Got:       " . (join ' ', map { qq[<<$_>>] } @$tok));
        is_deeply(
            $tok,
            $tokens,
            "make_tokens: <<$str>>"
        );
    };

    open my $megahal_trn, "<", 't/lib/Hailo/Test/megahal.trn';
    open my $megahal_trn_tokenized, "<", 't/tokenizer/MegaHAL/megahal.trn.make_tokens';

    while (my $trn = <$megahal_trn>) {
        chomp $trn;
        chomp(my $toke = <$megahal_trn_tokenized>);

        my @ok = $toke =~ m/<<(.*?)>>/g;
        @ok = grep { not /^\s+$/ } @ok;

        $t->($trn, \@ok);
    }


subtest make_output => sub {
    my @tokens = (
    );

    my $toke = Hailo::Tokenizer::MegaHAL->new();

    for my $test (@tokens) {
        my $tokens = $toke->make_tokens($test->[0]);
        my $t;
        push @$t, $_->[1] for @$tokens;
        is_deeply($t, $test->[1], 'Tokens are correct');
        my $output = $toke->make_output($tokens);
        is_deeply($output, $test->[2], 'Output is correct');
    }

    done_testing();
};
