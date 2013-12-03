'use strict';

angular.module('GeoHashingApp')
    .controller('EditMarkerCtrl', function ($scope, $rootScope, $route, $http) {

        $rootScope.textAngularOpts = {
            toolbar: [['h1', 'h2', 'h3', 'p', 'pre', 'bold', 'italics', 'ul', 'ol', 'redo', 'undo', 'clear'],['html', 'insertImage', 'insertLink']],
            classes: {
                toolbar: "btn-toolbar",
                toolbarGroup: "btn-group",
                toolbarButton: "btn btn-default",
                toolbarButtonActive: "active",
                textEditor: 'form-control',
                htmlEditor: 'form-control'
            }
        };

        $scope.id = $route.current.params.id;
        $scope.user = '';
        $scope.latitude = '';
        $scope.longitude = '';
        $scope.description = '';

        var getMarker = function(markerId){
            $http({method: 'GET', url: '/markers/get/marker/json/' + markerId}).
                success(function (data, status, headers, config) {
                    if(data && data.id){
                        showMarker(data);
                    }
                }).
                error(function (data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                });
        };

        if($scope.id){
            getMarker($scope.id);
        }

        $scope.submit = function(){
            var markerJson = {
                'id' : $scope.id,
                'user' : $scope.user,
                'latitude' : $scope.latitude,
                'longitude' : $scope.longitude,
                'description' : $scope.description
            };

            $http({method: 'POST', url: '/markers/edit/json', data:  markerJson }).
                success(function (data, status, headers, config) {
                    if(data && data.id){
                        showMarker(data);
                    }
                }).
                error(function (data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                });
        };



        var showMarker = function(markerJson){
            $scope.id = markerJson.id;
            $scope.user = markerJson.user;
            $scope.latitude = markerJson.latitude;
            $scope.longitude = markerJson.longitude;
            $scope.description = markerJson.description;
        };

    });

