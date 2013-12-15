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
            controller: 'MarkersListCtrl',
            data:{
                needAuth:  false
            }
        })
        .state('edit_marker', {
            url: '/edit/marker/:id',
            templateUrl: 'views/edit_marker.html',
            controller: 'EditMarkerCtrl',
            data:{
                needAuth:  true
            }
        })
        .state('add_marker', {
            url: '/add/marker',
            templateUrl: 'views/edit_marker.html',
            controller: 'EditMarkerCtrl',
            data:{
                needAuth:  true
            }
        })
        .state('show_marker',{
            url: '/show/:id',
            templateUrl: 'views/single_marker_view.html',
            controller: 'SingleMarkerViewCtrl',
            data:{
                needAuth:  false
            }
        });
});

geoHashingApp.config(function ($httpProvider) {

    var logsOutUserOn401 = ['$q', '$location', function ($q, $location) {
        var success = function (response) {
            return response;
        };

        var error = function (response) {
            if (response.status === 401) {
                //redirect them back to login page
                $location.path('/login');

                return $q.reject(response);
            }
            else {
                return $q.reject(response);
            }
        };

        return function (promise) {
            return promise.then(success, error);
        };
    }];

    $httpProvider.responseInterceptors.push(logsOutUserOn401);
});

geoHashingApp.run(function($rootScope, $location, AuthenticationService) {

   $rootScope.$on('$stateChangeStart', function (ev, to, toParams, from, fromParams) {
        // if route requires auth and user is not logged in
        if (to.data.needAuth && !AuthenticationService.isLoggedIn()) {
            // redirect back to login
            $location.path('/login');
        }
    });
});