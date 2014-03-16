angular.module('GeoHashingApp')
    .controller('PlaceMarkerController',['$scope', function($scope) {

    }])
    .directive('placeMarker',['geolocation', '$timeout', function(geolocation, $timeout) {

        return {
            scope: {
                'longitude': '=',
                'latitude' : '='
            },
            templateUrl: 'views/place_marker_directive.html',
            controller: function($scope){
                $scope.makerObject =  {
                    geometry: {
                        type: 'Point'
//                        coordinates: coords
                    },
                    properties: {
                        iconContent: 'Marker',
                        balloonContent: 'You can move me'
                    }
                }

//                INIT Yandex maps geolocation
                $scope.beforeInit = function(){

                    if(! ($scope.longitude && $scope.longitude) ){
                        geolocation.getLocation().then(function(data){
                            $scope.makerObject.geometry.coordinates = [data.coords.longitude, data.coords.latitude ];
                            $scope.center = $scope.makerObject.geometry.coordinates;
                        });

                        var yandexMapsGeolocation = ymaps.geolocation;
                        $scope.makerObject.geometry.coordinates = [yandexMapsGeolocation.longitude, yandexMapsGeolocation.latitude];
                   }

                    $scope.center = $scope.makerObject.geometry.coordinates;
                };

                $scope.dragEnd = function($event){
                    var coords = $event.get('target').geometry.getCoordinates();
                    $scope.longitude = coords[0];
                    $scope.latitude  = coords[1];
                };

            }

        };
    }]);
