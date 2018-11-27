use v5.28.0;
use strict;
use warnings;
use Test::Synopsis;
use Test::More tests => 1;

# TODO: Don't abuse the private API?
my ($synopsis) = Test::Synopsis::_extract_synopsis('lib/Hailo.pm');
$synopsis =~ s/^.*?(?=\s+use)//s;

local $@;
eval <<'SYNOPSIS';
open my $filehandle, '<', __FILE__;
chdir 't/lib/Hailo/Test';
$synopsis
SYNOPSIS

is($@, '', "No errors in SYNOPSIS");
