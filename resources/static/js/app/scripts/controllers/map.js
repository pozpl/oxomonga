'use strict';

angular.module('GeoHashingApp')
    .controller('MapController', function ($scope, $http) {
        var _map;

        $scope.afterInit=function(map){
            _map = map;
            var mapBounds = map.getBounds();
            _fetchMarkersForBounds(mapBounds);
        };

        $scope.reloadMarkersOnBoundsChange = function(event){
            var newBounds = event.get('newBounds');
            _fetchMarkersForBounds(newBounds);
        };

        var _fetchMarkersForBounds = function(newBounds){
            $http({method: 'GET', url: '/markers/rectangle/' + newBounds[0][0] +'/' + newBounds[0][1] +'/'
                + newBounds[1][0] +'/' + newBounds[1][1]  }).
                success(function (data, status, headers, config) {
                    processMarkers(data);
                }).
                error(function (data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                });
        };

        $scope.map = {
//            center: [43, 123],
            zoom: 12
        };

        var fetchMarkersRadius = function (latitude, longitude, radius) {
            $http({method: 'GET', url: '/markers/near/radius/' + longitude + '/' + latitude + '/' + radius}).
                success(function (data, status, headers, config) {
                    processMarkers(data);
                }).
                error(function (data, status, headers, config) {
                    // called asynchronously if an error occurs
                    // or server returns response with an error status.
                });
        };


        var processMarkers = function (data) {
            if (data && data.length > 0) {
                $scope.geoObjects = [];
                $scope.shared.markers = [];
                angular.forEach(data, function (marker, index) {
//                    addMarkerToSharedMarkers(marker);
                    $scope.shared.markers.push(marker);
                    $scope.geoObjects.push(
                        {
                            geometry: {
                                type: 'Point',
                                coordinates: [marker.longitude, marker.latitude]
                            },
                            properties: {
//                                iconContent: marker.id,
                                balloonContent: marker.description,
                                id : marker.id
                            }
                        }
                    );
                });
            }
        };




//        var addMarkerToSharedMarkers = function(marker){
//             if(! $scope.shared.markersIds[marker.id] ){
//                $scope.shared.markersIds[marker.id] = true;
//                $scope.shared.markers.push(marker);
//             }
//        };

    }
);
