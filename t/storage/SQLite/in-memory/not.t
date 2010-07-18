use 5.010;
use strict;
use warnings;
use Hailo;
use File::Temp qw(tempdir tempfile);
use Test::More tests => 3;

# Dir to store our brains
my $dir = tempdir( "hailo-test-sqlite-in-memory-not-XXXX", CLEANUP => 1, TMPDIR => 1 );

my ($fh, $brain_file) = tempfile( DIR => $dir, SUFFIX => '.sqlite', EXLOCK => 0 );

my $hailo = Hailo->new(
    storage_class  => 'SQLite',
    brain          => $brain_file,
);

isnt($hailo->brain, ':memory:', sprintf "Hailo is using %s as a brain, not :memory", $hailo->brain);
ok(!$hailo->_storage->arguments->{in_memory}, "SQLite's in_memory argument is false, so we're not running it hybrid disk->memory mode");

# we need to learn something first so the DB file will be initialized
$hailo->learn('foo bar baz');

my $orig_size = -s $brain_file;
$hailo->train(__FILE__);
my $new_size = -s $brain_file;

isnt($new_size, $orig_size, "Hailo wrote the things it learned to disk. Brain was $orig_size, now $new_size");
