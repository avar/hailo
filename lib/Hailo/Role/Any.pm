package Hailo::Role::Any;

use 5.010;
use strict;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

1;
