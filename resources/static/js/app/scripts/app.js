'use strict';

angular.module('GeoHashingApp', ['ngRoute', 'yaMap', 'textAngular'])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MarkersListCtrl'
      })
        .when('/edit/marker/{id}',{
            templateUrl: 'views/edit_marker.html',
            controller: 'EditMarkerCtrl'
        })
      .otherwise({
        redirectTo: '/'
      });
  });
