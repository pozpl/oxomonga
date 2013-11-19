'use strict';

angular.module('GeoHashingApp')
    .controller('MainCtrl', function ($scope, $http) {
//        $scope.geoObjects=[
//            {
//                geometry: {
//                    type: 'Point',
//                    coordinates: [37.8,55.8]
//                },
//                properties: {
//                    iconContent: 'Метка',
//                    balloonContent: 'Меня можно перемещать'
//                }
//            },
//            {
//                geometry: {
//                    type: 'Point',
//                    coordinates: [37.6,55.8]
//                },
//                properties: {
//                    iconContent: '1',
//                    balloonContent: 'Балун',
//                    hintContent: 'Стандартный значок метки'
//                }
//            },
//            {
//                geometry: {
//                    type: 'Point',
//                    coordinates: [37.56,55.76]
//                },
//                properties: {
//                    hintContent: 'Собственный значок метки'
//                }
//            }
//        ];
////
//        $scope.map = {
//            center: [37.64,55.76], zoom: 8
//        };

        $http({method: 'GET', url: '/markers/near/radius/123/43/100'}).
            success(function (data, status, headers, config) {
                console.log(data.length);
                if(data && data.length > 0){
                    $scope.geoObjects = [];
                    angular.forEach(data, function(index, marker){
                        $scope.geoObjects.push(
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


                    $scope.map = {
                        center: [43, 123], zoom: 12
                    };
                    console.log('All loaded');
                }
            }).
            error(function (data, status, headers, config) {
                // called asynchronously if an error occurs
                // or server returns response with an error status.
            });

    });
