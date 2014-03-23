'use strict';

var geoHashingApp = angular.module('GeoHashingApp',
            ['ngRoute', 'yaMap', 'textAngular', 'ui.router', 'angularFileUpload', 'ngCookies', 'geolocation']);

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
        .state('login_state', {
            url: "/login",
            templateUrl: 'views/login.html',
            controller: 'LoginCtrl',
            data:{
                needAuth:  false
            }
        })
        .state('logout_state', {
            url: "/logout",
            controller: 'LogOutCtrl',
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
        })
        .state('register_user', {
            url: "/registration",
            templateUrl: 'views/register_user.html',
            controller: 'RegisterUserCtrl',
            data:{
                needAuth:  false
            }
        })
        .state('edit_user',{
            url: "/userprofile/:id",
            templateUrl: 'views/edit_user.html',
            controller: 'EditUserCtrl',
            data:{
                needAuth:  true
            }
        });
});

geoHashingApp.config(function ($httpProvider) {

    var logsOutUserOn401 = ['$q', '$location', '$rootScope', function ($q, $location, rootScope) {
        var success = function (response) {
            return response;
        };

        var error = function (response) {
            if (response.status === 401) {
                //redirect them back to login page
                rootScope.$broadcast('event:loginRequired');
//                var deferred = $q.defer();
//                var req = {
//                    config: response.config,
//                    deferred: deferred
//                }
//                scope.$broadcast('event:loginRequired');
//                return deferred.promise;


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

geoHashingApp.run([ '$rootScope', '$location', 'AuthenticationService',
    function ($rootScope, $location, AuthenticationService) {

        $rootScope.$on('event:loginRequired', function(){
            AuthenticationService.setLoggedIn(false);

            //Only redirect if we aren't on create or login pages.
            if($location.path() == "/create" || $location.path() == "/login")
                return;
            scope.pageWhen401 = $location.path();

            //go to the login page
            $location.path('/login').replace();
        });

        $rootScope.$on('$stateChangeStart', function (ev, to, toParams, from, fromParams) {
            // if route requires auth and user is not logged in
            if (to.data.needAuth && !AuthenticationService.isLoggedIn()) {
                // redirect back to login
                AuthenticationService.setLastUnauthenticatedState(to);
                AuthenticationService.setLastUnauthenticatedStateParams(toParams);

                $location.path('/login');
            }
        });
    }]);