'use strict';

var geoHashingApp = angular.module('GeoHashingApp', ['ngRoute', 'yaMap', 'textAngular', 'ui.router']);

geoHashingApp.config(function($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise("/");
    //
    // Now set up the states
    $stateProvider
        .state('main_state', {
            url: "/",
            templateUrl: 'views/main.html',
            controller: 'MarkersListCtrl'
        })
        .state('edit_marker', {
            url: '/edit/marker/:id',
            templateUrl: 'views/edit_marker.html',
            controller: 'EditMarkerCtrl'
        })
        .state('add_marker', {
            url: '/add/marker',
            templateUrl: 'views/edit_marker.html',
            controller: 'EditMarkerCtrl'
        })
        .state('show_marker',{
            url: '/show/:id',
            templateUrl: 'views/single_marker_view.html',
            controller: 'SingleMarkerViewCtrl'
        });
});

//    config(function ($routeProvider) {
//    $routeProvider
//        .when('/', {
//            templateUrl: 'views/main.html',
//            controller: 'MarkersListCtrl'
//        })
//        .when('/edit/marker/:id?', {
//            templateUrl: 'views/edit_marker.html',
//            controller: 'EditMarkerCtrl'
//        })
//        .when('/show/:id')
//        .otherwise({
//            redirectTo: 'views/single_marker_view.html',
//            controller: 'SingleMarkerViewCtrl'
//        });
//});
