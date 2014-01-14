#!/usr/bin/perl

use Test::Simple tests=> 21;
use warnings;
use strict;
use Test::MockObject;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;

use Markers::MarkerRepository;
use Markers::Marker;
use Data::Dump qw(dump);


my $marker =  Markers::Marker->new(
    'user' => 'pozpl',
    'longitude' => 131.894030,
    'latitude' => 43.124584,
    'time_of_creation' => time(),
    'description' => 'simple description',
    'images' => ['image_1', 'image2']
);

my $mongo = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('test');
my $markers_collection = $test_database->get_collection('markers_collection');
$markers_collection->drop();
$markers_collection->ensure_index({'loc' => '2dsphere'});
my $markers_repository = Markers::MarkerRepository->new('markers_collection' => $markers_collection);

my $fictional_saved_marker = $markers_repository->save_marker($marker);
my $saved_marker = $markers_repository->save_marker($marker);
my $found_marker = $markers_repository->find_by_id($saved_marker->id());

ok(defined $found_marker, 'Somthing is found');
ok($marker->user eq $found_marker->user, 'user equals');
ok($marker->longitude == $found_marker->longitude, 'longitude ok');
ok($marker->latitude == $found_marker->latitude, 'latitude ok');
ok($marker->description eq $found_marker->description, 'description ok');
ok(@{$marker->images} == 2, 'Images count is ok');
ok(@{$marker->images}[0] eq 'image_1', 'Imagein array');


my @near_markers = $markers_repository->find_near_markers(131.894030, 43.124584, 1000);
ok(@near_markers, 'A marker found near the target point');
ok(@near_markers > 0, 'Markers count is greater than zerro');
ok($marker->longitude == $near_markers[0]->longitude, 'longitude ok');
ok($marker->latitude == $near_markers[0]->latitude, 'latitude ok');


@near_markers = $markers_repository->find_markers_in_rectangle(130, 42, 132, 44,);
ok(@near_markers, 'A marker found near the target point');
ok(@near_markers > 0, 'Markers count is greater than zerro');
ok($marker->longitude == $near_markers[0]->longitude, 'longitude ok');
ok($marker->latitude == $near_markers[0]->latitude, 'latitude ok');


my $image_id_1 = "f1488666100500";
my $image_id_2 = "f1488666100501";
my $image_id_3 = "f1488666100500";
$markers_repository->add_image_to_marker($saved_marker->id(), $image_id_1);
$markers_repository->add_image_to_marker($saved_marker->id(), $image_id_2);
$markers_repository->add_image_to_marker($saved_marker->id(), $image_id_3);

my $marker_with_images = $markers_repository->find_by_id($saved_marker->id());
#print dump $marker_with_images;
ok(@{$marker_with_images->images()} == 4, 'Unique images are 4');
my @grep_res =grep {$_ eq $image_id_1 } @{$marker_with_images->images()};
ok($grep_res[0], 'image_1 is present' );
@grep_res =grep {$_ eq $image_id_1 } @{$marker_with_images->images()};
ok($grep_res[0], 'image_2 is present' );

$markers_repository->delete_image_from_marker($saved_marker->id(), $image_id_2);
$marker_with_images = $markers_repository->find_by_id($saved_marker->id());
#print dump $marker_with_images;
ok(@{$marker_with_images->images()} == 3, 'Unique images are 3');

$markers_repository->delete_image_from_marker($saved_marker->id(), $image_id_1);
$markers_repository->delete_image_from_marker($saved_marker->id(), $image_id_2);
$markers_repository->delete_image_from_marker($saved_marker->id(), $image_id_3);

$marker_with_images = $markers_repository->find_by_id($saved_marker->id());
print @{$marker_with_images->images()};
ok(@{$marker_with_images->images()} == 2, 'remained images 2');

$markers_repository->add_images_to_marker($saved_marker->id(), [$image_id_1, $image_id_2, $image_id_3]);
$marker_with_images = $markers_repository->find_by_id($saved_marker->id());
#print dump $marker_with_images;
ok(@{$marker_with_images->images()} == 4, 'Unique images are 4');

$markers_collection->drop();