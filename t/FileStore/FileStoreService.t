use Test::Simple tests=> 2;
use warnings;
use strict;
use Test::MockObject;

use FileStore::FileStoreService;

$file_store = FileStore::FileStoreService->new(
    'root_path' => '/tmp',
    'url_base' => 'http://urbancamper.ru/cdn/images/'
);

open my $file_to_create, '<', '/tmp/temp_file';
close($file_to_create);
#$file_store->

