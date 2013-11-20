'use strict';

angular.module('GeoHashingApp')
    .controller('MapController', function ($scope, $http) {
        $scope.map = {
            center: [37.64,55.76],
            zoom: 12
        };


        $http({method: 'GET', url: '/markers/near/radius/123/43/100'}).
            success(function (data, status, headers, config) {
                console.log(data.length);
                if(data && data.length > 0){
                    $scope.geoObjects = [];
                    var averageAltitude = 0;
                    var averageLongitude = 0;
                    angular.forEach(data, function(index, marker){
                        averageAltitude = marker.latitude;
                        averageLongitude = marker.longitude;
                        $scope.geoObjects .push(
                            {
                                geometry: {
                                    type: 'Point',
                                    coordinates: [marker.latitude, marker.longitude]
                                },
                                properties: {
                                    iconContent: 'Метка',
                                    balloonContent: marker.description
                                }
                            }
                        );
                    });

                    averageAltitude = averageAltitude / data.length;
                    averageLongitude = averageLongitude / data.length;


                    $scope.map = {
                        center: [averageAltitude, averageLongitude]
                    };
                    console.log('All loaded');
                }
            }).
            error(function (data, status, headers, config) {
                // called asynchronously if an error occurs
                // or server returns response with an error status.
            });

    });
