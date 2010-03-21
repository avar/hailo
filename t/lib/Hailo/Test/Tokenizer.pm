package Hailo::Test::Tokenizer;
use 5.010;
use strict;
use parent 'Hailo::Role::Tokenizer';

die "XXX: This isn't called anymore!";

sub make_tokens { goto &Hailo::Tokenizer::Words::make_tokens }
sub make_output { goto &Hailo::Tokenizer::Words::make_output }

1;
