use v5.28.0;
use lib 't/lib';
use strict;
use warnings;
use Hailo::Test;
use Test::More;

my $test = Hailo::Test->new(
    storage => "SQLite",
);
$test->test_all_plan;
