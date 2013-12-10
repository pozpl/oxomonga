'use strict';

angular.module('GeoHashingApp')
    .controller('SingleMarkerViewCtrl', function ($scope, $stateParams, $http) {

        $scope.markerId = $stateParams.id;
        $scope.user = '';
        $scope.latitude = '';
        $scope.longitude = '';
        $scope.description = '';
        $scope.images = new Array();


        var getMarker = function (markerId) {
            $http({method: 'GET', url: '/markers/get/marker/json/' + markerId}).
                success(function (data, status, headers, config) {
                    if (data && data.id) {
                        showMarker(data);
                    }
                }).
                error(function (data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                });
        };

        if ($scope.markerId) {
            getMarker($scope.markerId);
        }

        var showMarker = function (markerJson) {
            $scope.markerId = markerJson.id;
            $scope.user = markerJson.user;
            $scope.latitude = markerJson.latitude;
            $scope.longitude = markerJson.longitude;
            $scope.description = markerJson.description;
            $scope.images = markerJson.images;
        };


    });

