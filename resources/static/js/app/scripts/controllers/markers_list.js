'use strict';

angular.module('GeoHashingApp')
    .controller('MarkersListCtrl', function ($scope, $http) {
        $scope.shared = new Object();
        $scope.shared.markersIds = new Object();
        $scope.shared.markers = Array();


        $scope.runBalloon = function(obj){
            $scope.shared.showBallonIs = obj.id;
        };

    });
