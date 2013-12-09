'use strict';

var geoHashingApp = angular.module('GeoHashingApp', ['ngRoute', 'yaMap', 'textAngular', 'ui.router']);

geoHashingApp.config(function($stateProvider, $urlRouterProvider) {
    //
    // For any unmatched url, redirect to /state1
    $urlRouterProvider.otherwise("/");
    //
    // Now set up the states
    $stateProvider
        .state('main_state', {
            url: "/",
            templateUrl: 'views/main.html',
            controller: 'MarkersListCtrl'
        })
        .state('/edit/marker/:id?', {
            templateUrl: 'views/edit_marker.html',
            controller: 'EditMarkerCtrl'
        })
        .state('show_marker',{
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
