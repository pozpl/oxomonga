#!/usr/bin/perl

use Test::Simple tests=> 9;
use warnings;
use strict;
use Test::MockObject;

use MongoDB;
use MongoDB::MongoClient;
use MongoDB::OID;

use Auth::UsersRepository;
use Auth::User;
use Data::Dump qw(dump);


my $user =  Auth::User->new(
    'login' => 'login1',
    'email' => 'email@email.com',
    'friendly_name' => 'User Friendly',
    'provider' => 'provider_name',
    'avatar' => 'avatar_image_id',
    'password' => 'simple_enough_password'
);

my $mongo = MongoDB::MongoClient->new;
my $test_database = $mongo->get_database('test');
my $users_collection = $test_database->get_collection('users_collection');
$users_collection->drop();
my $users_repository = Auth::UsersRepository->new('users_collection' => $users_collection);

my $saved_user = $users_repository->save_user($user);
my $found_user = $users_repository->find_by_id($saved_user->id());

ok(defined $found_user, 'Somthing is found');
ok($user->login eq $found_user->login, 'login equals');
ok($user->friendly_name eq $found_user->friendly_name, 'friendly_name ok');
ok($user->email eq $found_user->email, 'email ok');
ok($user->provider eq $found_user->provider, 'provider ok');
ok($user->avatar eq $found_user->avatar, 'avatar ok');

ok($users_repository->check_user_password($found_user->id, $user->password), 'password ok');
ok(!$users_repository->check_user_password($found_user->id, 'gibberish'), 'password ok');


ok($users_repository->delete_by_id($found_user->id), 'user delete ok');

$users_collection->drop();
