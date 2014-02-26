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

                    var coords = [];
                    if($scope.longitude && $scope.longitude){
                        coords = [$scope.longitude, $scope.longitude]
                    }else{
                        var geolocation = ymaps.geolocation;
                        coords = [geolocation.longitude, geolocation.latitude];
                    }
                    $scope.center = coords;

                    $scope.makerObject =  {
                        geometry: {
                            type: 'Point',
                            coordinates: coords //[$scope.longitude, $scope.latitude]
                        },
                        properties: {
                            iconContent: 'Метка',
                            balloonContent: 'Меня можно перемещать',
                            draggable: true
                        }
                    }
                }
            }

        };
    }]);
