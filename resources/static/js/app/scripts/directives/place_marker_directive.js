angular.module('GeoHashingApp')
    .controller('PlaceMarkerController',['$scope' , function($scope) {

    }])
    .directive('placeMarker', function() {
        return {
            scope: {
                'longitude': '=',
                'latitude' : '='
            },
            templateUrl: 'views/place_marker_directive.html'
        };
    });
