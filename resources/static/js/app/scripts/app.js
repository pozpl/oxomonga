'use strict';

angular.module('GeoHashingApp', ['ngRoute', 'yaMap'])
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MarkersListCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
