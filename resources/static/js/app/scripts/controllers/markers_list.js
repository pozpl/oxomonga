'use strict';

angular.module('GeoHashingApp')
    .controller('MarkersListCtrl', function ($scope, $http) {
        $scope.shared = new Object();
        $scope.shared.markersIds = new Object();
        $scope.shared.markers = Array();
        $scope.shared.showBalloonId = 0;

        $scope.runBalloon = function(obj){
            if($scope.shared.showBalloonId == obj.id){
                $scope.shared.showBalloonId = obj.id;
            }else{
                $scope.shared.showBalloonId = -1;
            }

        };

    });
