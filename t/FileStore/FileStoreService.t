use Test::Simple tests=> 2;
use warnings;
use strict;
use Test::MockObject;

use FileStore::FileStoreService;

my $file_store = FileStore::FileStoreService->new(
    'root_path' => '/tmp',
    'url_base' => 'http://urbancamper.ru/cdn/images/'
);

my $file_initial_path = '/tmp/temp_file';
open my $file_to_create, '<', $file_file_initial_path;
print $file_to_create "fancy text";
close($file_to_create);
$file_id = $file_store->store_file($file_file_initial_path);
ok(lenght($file_id) > 0, 'File id is no null');

$is_existed = $file_store->delete_file_by_id($file_id);
ok($is_existed, 'File was deleted from store');

unlink $file_file_initial_path;

