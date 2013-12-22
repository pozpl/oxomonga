#!/usr/bin/perl

use Test::Simple tests=> 15;
use warnings;
use strict;
use Test::MockObject;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;

use Markers::MarkerRepository;
use Markers::Marker;



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


my @near_markers = $markers_repository->find_markers_in_rectangle(130, 42, 132, 44,);
ok(@near_markers, 'A marker found near the target point');
ok(@near_markers > 0, 'Markers count is greater than zerro');
ok($marker->longitude == $near_markers[0]->longitude, 'longitude ok');
ok($marker->latitude == $near_markers[0]->latitude, 'latitude ok');

my $image_id_1 = "1488666100500";
my $image_id_2 = "1488666100501";
my $image_id_3 = "1488666100500";
$markers_repository->add_image_to_marker($saved_marker->id(), $image_image_id_1);
$markers_repository->add_image_to_marker($saved_marker->id(), $image_image_id_2);
$markers_repository->add_image_to_marker($saved_marker->id(), $image_image_id_3);

my $marker_with_images = $markers_markers_repository->find_by_id($saved_marker->id());
ok(@{$marker_marker_with_images->images()} == 2, 'Unique images are 2');


$markers_collection->drop();