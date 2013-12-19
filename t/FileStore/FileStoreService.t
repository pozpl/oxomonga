use Test::Simple tests=> 2;
use warnings;
use strict;
use Test::MockObject;

use FileStore::FileStoreService;

my $url_base = 'http://urbancamper.ru/cdn/images/';
my $file_store = FileStore::FileStoreService->new(
    'root_path' => '/tmp',
    'url_base' => $url_base,
);

my $file_initial_path = '/tmp/temp_file';
open my $file_to_create, '>', $file_initial_path;
print $file_to_create "fancy text";
close($file_to_create);
my  $file_id = $file_store->store_file($file_initial_path);
ok(length($file_id) > 0, 'File id is no null');

my $url_for_file = $file_store->get_url_for_id($file_id);
ok($url_for_file =~ qr/$url_for_file/);


my $is_existed = $file_store->delete_file_by_id($file_id);
ok($is_existed, 'File was deleted from store');

unlink $file_initial_path;

