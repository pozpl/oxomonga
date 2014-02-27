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

                $scope.beforeInit = function(){

                    if(! ($scope.longitude && $scope.longitude) ){
                        var geolocation = ymaps.geolocation;
                        $scope.longitude = geolocation.longitude;
                        $scope.latitude =  geolocation.latitude;
                    }
                    var coords = [$scope.longitude, $scope.longitude];
                    $scope.center = coords;

                    $scope.makerObject =  {
                        geometry: {
                            type: 'Point',
                            coordinates: coords
                        },
                        properties: {
                            iconContent: 'Marker',
                            balloonContent: 'You can move me',
                            draggable: true
                        }
                    }
                }
            }

        };
    }]);
