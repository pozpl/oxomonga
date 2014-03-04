angular.module('GeoHashingApp')
    .controller('PlaceMarkerController',['$scope', function($scope) {

    }])
    .directive('placeMarker',[function() {

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

                $scope.beforeInit = function(){

                    if(! ($scope.longitude && $scope.longitude) ){
                        var geolocation = ymaps.geolocation;
                        $scope.longitude = geolocation.longitude;
                        $scope.latitude =  geolocation.latitude;
                    }
                    var coords = [$scope.longitude, $scope.latitude];
                    $scope.center = coords;

                    $scope.makerObject.geometry.coordinates = coords;
                };

                $scope.dragEnd = function($event){
                    var coords = $event.get('target').geometry.getCoordinates();
                    $scope.longitude = coords[0];
                    $scope.latitude  = coords[1];
                };

            }

        };
    }]);
